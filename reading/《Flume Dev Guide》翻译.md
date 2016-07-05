>Apache Flume是分布式、可靠的、高可用的日志搜集、汇总、传输工具。目前有两个版本，0.9.x和1.x，本文档是基于1.x的。目前提供的最新版本是1.6.

# 架构

## 数据流模型

在Flume节点中是以Event为数据单元，Event从`source`经过`channel`交给`sink`。Event对象携带了payload信息（由一系列的数据以及headers组成，可以理解成一个hash表）。Flume节点是一个JVM的进程，并由一系列的节点组成，使event对象可以从外部的数据源到达目的地。

source会以特定的格式产生event对象，可以把source看做event的产生服务器。举个栗子，avroSource可以接受其他的Flume节点产生的Avro的信息，产生event对象。当source接收到事件event后，会把它存储在channel中。channel被动的存储数据，直到event被sink取走。channel有多种类型可以选择，比如fileChannel选择使用文件系统存储。sink负责把event从channel中取出，然后放入指定的存储源中，如HDFS或者转发给其他的flume节点。source和sink处理channel中的event对象都是异步运行的。

## 可靠性

event事件在channel中声明，sink负责转发event给下一个节点或者最终的存储点（如HDFS）。当event在下一个节点的channel中存储或者存储在最终存储点时，sink会删除channel中的事件。这种点到点的方式保证了数据传输的可靠性。source和sink在处理channel中的数据时，会经过一定的封装，这样可以保证节点之间传输的可靠性。在多节点的情况下，前一节点的sink会维护与下一节点的source之间的会话，保证传输的可靠性。

# 构建Flume

1 下载代码

```
git clone https://git-wip-us.apache.org/repos/asf/flume.git
```

2 执行编译

```
1. Compile only: mvn clean compile
2. Compile and run unit tests: mvn clean test
3. Run individual test(s): mvn clean test -Dtest=<Test1>,<Test2>,... -
DfailIfNoTests=false
4. Create tarball package: mvn clean install
5. Create tarball package (skip unit tests): mvn clean install -DskipTests
```

# 自定义开发组件


### 客户端

客户端操作事件对象的源头，并且把他们发送给flume节点。client最典型的就是处理应用进程产生的数据。目前flume支持Avro,log4j,syslog,http等数据源类型。另外，也有一种execsource类型可以消费本地进程输出的信息。

退出选项不够充分这种情况是很重要的，在这种情况下，如何创建一种自定义的机制发送数据。有两种方式：

- 第一种就是创建自定义的客户端与flume的source进行交互，比如AvroSource和SyslogTcpSource。这样client需要把数据转换成flume理解的格式。
- 第二种，是自定义中flume source基于IPC或者RPC协议与本地进程进行沟通，然后把数据传给flume节点。

注意，所有的数据都是存储在flume节点的channel中。

### client SDK

尽管flume包含了一系列的数据产生机制，但是很多场景下还是需要与自定义的应用进行交互。Flume SDK可以帮助开发者使用RPC协议与应用进行连接。

[RPC参考1：浅出](http://blog.csdn.net/mindfloating/article/details/39473807)

[RPC参考2：深入](http://blog.csdn.net/mindfloating/article/details/39474123/)

### RPC 客户端接口

实现RpcClient接口可以把Flume封装起来。用户仅需要调用Flume的API方法，append以及appendBatch即可发送数据，不需要关心详细的消息信息。用户可以使用提供的Event对象，或者使用EventBuilder方法重写withBody()方法。

### RPC 客户端 - Avro 以及 Thrift

Avro是默认的RPC协议，NettyAvroRpcClient以及ThriftRpcClient都实现了RpcClient接口。客户端需要创建目标Agent的主机名以及端口号，并且使用RpcClient发送数据。下面就是一个数据产生的应用：
```
import org.apache.flume.Event;
import org.apache.flume.EventDeliveryException;
import org.apache.flume.api.RpcClient;
import org.apache.flume.api.RpcClientFactory;
import org.apache.flume.event.EventBuilder;
import java.nio.charset.Charset;
public class MyApp {
	public static void main(String[] args) {
		MyRpcClientFacade client = new MyRpcClientFacade();
		// 初始化主机名以及端口号
		client.init("host.example.org", 41414);
		// 发送给远程节点10条数据
		String sampleData = "Hello Flume!";
		for (int i = 0; i < 10; i++) {
			client.sendDataToFlume(sampleData);
		}
		client.cleanUp();
	}
}
class MyRpcClientFacade {
	private RpcClient client;
	private String hostname;
	private int port;
	public void init(String hostname, int port) {
		// 初始化RPC客户端
		this.hostname = hostname;
		this.port = port;
		this.client = RpcClientFactory.getDefaultInstance(hostname, port);
		// 使用下面的方法创建thrift的客户端
		// this.client = RpcClientFactory.getThriftInstance(hostname, port);
	}
	public void sendDataToFlume(String data) {
		// 创建事件对象
		Event event = EventBuilder.withBody(data, Charset.forName("UTF-8"));
		try {// 发送事件
			client.append(event);
		} catch (EventDeliveryException e) {
			// 清除信息，重建Client
			client.close();
			client = null;
			client = RpcClientFactory.getDefaultInstance(hostname, port);
	}
}
	public void cleanUp() {
		// 关闭RPC连接
		client.close();
	}
}
```

远程的Flume节点需要有一个AvroSource的source，来监听某个端口。下面就是配置的例子：
```
a1.channels = c1
a1.sources = r1
a1.sinks = k1
a1.channels.c1.type = memory
a1.sources.r1.channels = c1
a1.sources.r1.type = avro
# For using a thrift source set the following instead of the above line.
# a1.source.r1.type = thrift
a1.sources.r1.bind = 0.0.0.0
a1.sources.r1.port = 41414
a1.sinks.k1.channel = c1
a1.sinks.k1.type = logger
```
如果想要更灵活，可以使用默认的flume客户端实现方式（NettyAvroRpcClient以及ThriftRpcClient）可以参考下面的配置:
```
client.type = default (for avro) or thrift (for thrift)
hosts = h1 # default client accepts only 1 host
# (additional hosts will be ignored)
hosts.h1 = host1.example.org:41414 # host and port must both be specified
# (neither has a default)
batch-size = 100 # Must be >=1 (default: 100)
connect-timeout = 20000 # Must be >=1000 (default: 20000)
request-timeout = 20000 # Must be >=1000 (default: 20000)
```

## 什么是RPC？
RPC（Remote Procedure Call Protocol）——远程过程调用协议

### 安全的RPC 客户端 —— Thrift

在1.6版本中，Thrift的source和sink支持kerberos认证。客户端需要使用secureRpcClientFactory的getThriftInstance方法获得SecureThriftRpcClient对象。SecureThriftClient继承ThriftRpcClient（实现了RpcClient接口）。使用SecureRpcClientFactory依赖于Flume-ng-auth模块。客户端的principal以及keytab都需要通过参数的形式传入，他们作为kerberos KDC的证书。另外，目标服务器的principal也需要提供。下面就是secureRpclientFacotry的例子：
```
import org.apache.flume.Event;
import org.apache.flume.EventDeliveryException;
import org.apache.flume.event.EventBuilder;
import org.apache.flume.api.SecureRpcClientFactory;
import org.apache.flume.api.RpcClientConfigurationConstants;
import org.apache.flume.api.RpcClient;
import java.nio.charset.Charset;
import java.util.Properties;
public class MyApp {
public static void main(String[] args) {
MySecureRpcClientFacade client = new MySecureRpcClientFacade();
// Initialize client with the remote Flume agent's host, port
Properties props = new Properties();
props.setProperty(RpcClientConfigurationConstants.CONFIG_CLIENT_TYPE, "thrift");
props.setProperty("hosts", "h1");
props.setProperty("hosts.h1", "client.example.org"+":"+ String.valueOf(41414));
// Initialize client with the kerberos authentication related properties
props.setProperty("kerberos", "true");
props.setProperty("client-principal", "flumeclient/client.example.org@EXAMPLE.ORG"
props.setProperty("client-keytab", "/tmp/flumeclient.keytab");
props.setProperty("server-principal", "flume/server.example.org@EXAMPLE.ORG");
client.init(props);
// Send 10 events to the remote Flume agent. That agent should be
// configured to listen with an AvroSource.
String sampleData = "Hello Flume!";
for (int i = 0; i < 10; i++) {
client.sendDataToFlume(sampleData);
}
client.cleanUp();
}
}
class MySecureRpcClientFacade {
private RpcClient client;
private Properties properties;
public void init(Properties properties) {
// Setup the RPC connection
this.properties = properties;
// Create the ThriftSecureRpcClient instance by using SecureRpcClientFactory
this.client = SecureRpcClientFactory.getThriftInstance(properties);
}
public void sendDataToFlume(String data) {
// Create a Flume Event object that encapsulates the sample data
Event event = EventBuilder.withBody(data, Charset.forName("UTF-8"));
// Send the event
try {
client.append(event);
} catch (EventDeliveryException e) {
// clean up and recreate the client
client.close();
client = null;
client = SecureRpcClientFactory.getThriftInstance(properties);
}
}
public void cleanUp() {
// Close the RPC connection
client.close();
}
}
```
ThriftSource则需要配置成kerberos模式。
```
a1.channels = c1
a1.sources = r1
a1.sinks = k1
a1.channels.c1.type = memory
a1.sources.r1.channels = c1
a1.sources.r1.type = thrift
a1.sources.r1.bind = 0.0.0.0
a1.sources.r1.port = 41414
a1.sources.r1.kerberos = true
a1.sources.r1.agent-principal = flume/server.example.org@EXAMPLE.ORG
a1.sources.r1.agent-keytab = /tmp/flume.keytab
a1.sinks.k1.channel = c1
a1.sinks.k1.type = logger
```
### 容错机制

下面的类使用的是默认的Avro RPC Client，它基于`<host>:<port>`的列表组成容错组。容错RPC Client目前不支持Thrift.如果当前与指定的agent通信出错，则会自动选取列表中的下一个通信。比如：
```
// Setup properties for the failover
Properties props = new Properties();
props.put("client.type", "default_failover");
// List of hosts (space-separated list of user-chosen host aliases)
props.put("hosts", "h1 h2 h3");
// host/port pair for each host alias
String host1 = "host1.example.org:41414";
String host2 = "host2.example.org:41414";
String host3 = "host3.example.org:41414";
props.put("hosts.h1", host1);
props.put("hosts.h2", host2);
props.put("hosts.h3", host3);
// create the client with failover properties
RpcClient client = RpcClientFactory.getInstance(props);
```
为了更灵活一些，failover flume client实现FailoverRpcClient，可以基于下面的配置：
```
client.type = default_failover
hosts = h1 h2 h3 # at least one is required, but 2 or
# more makes better sense
hosts.h1 = host1.example.org:41414
hosts.h2 = host2.example.org:41414
hosts.h3 = host3.example.org:41414
max-attempts = 3 # Must be >=0 (default: number of hosts
# specified, 3 in this case). A '0'
# value doesn't make much sense because
# it will just cause an append call to
# immmediately fail. A '1' value means
# that the failover client will try only
# once to send the Event, and if it
# fails then there will be no failover
# to a second client, so this value
# causes the failover client to
# degenerate into just a default client.
# It makes sense to set this value to at
# least the number of hosts that you
# specified.
batch-size = 100 # Must be >=1 (default: 100)
connect-timeout = 20000 # Must be >=1000 (default: 20000)
request-timeout = 20000 # Must be >=1000 (default: 20000)
```
### 负载均衡

Flume客户端SDK也支持在多个主机中负载均衡。client使用`<host>:<port>`的形式组成一个负载均衡组。client端会配置负载均衡的策略，可能是随机选择配置的主机，也可能是基于轮询的模式。你可以通过实现LoadBalancingRpcClient$HostSelector接口，指定自定义的类。在这种情况下，FQCN需要指定成特定的host selector.负载均衡RPC目前不支持Thrift.

如果backoff可用，那么在主机失败进行选举的时候会排除名单中的主机。当超时后，如果这个主机仍然不可用就会认为选举失败，超时时间会以指数级增长，以避免某些主机反应迟钝

最大的backoff事件可以通过maxBackoff进行配置。默认是30S（在OrderSelector中指定）。backoff 参数会以指数级增长。最大限制为65536秒，即18.2小时。
```
// Setup properties for the load balancing
Properties props = new Properties();
props.put("client.type", "default_loadbalance");
// List of hosts (space-separated list of user-chosen host aliases)
props.put("hosts", "h1 h2 h3");
// host/port pair for each host alias
String host1 = "host1.example.org:41414";
String host2 = "host2.example.org:41414";
String host3 = "host3.example.org:41414";
props.put("hosts.h1", host1);
props.put("hosts.h2", host2);
props.put("hosts.h3", host3);
props.put("host-selector", "random"); // For random host selection
// props.put("host-selector", "round_robin"); // For round-robin host
// // selection
props.put("backoff", "true"); // Disabled by default.
props.put("maxBackoff", "10000"); // Defaults 0, which effectively
// becomes 30000 ms
// Create the client with load balancing properties
RpcClient client = RpcClientFactory.getInstance(props);
```
也可以直接如下配置:
```
client.type = default_loadbalance
hosts = h1 h2 h3 # At least 2 hosts are required
hosts.h1 = host1.example.org:41414
hosts.h2 = host2.example.org:41414
hosts.h3 = host3.example.org:41414
backoff = false # Specifies whether the client should
# back-off from (i.e. temporarily
# blacklist) a failed host
# (default: false).
maxBackoff = 0 # Max timeout in millis that a will
# remain inactive due to a previous
# failure with that host (default: 0,
# which effectively becomes 30000)
host-selector = round_robin # The host selection strategy used
# when load-balancing among hosts
# (default: round_robin).
# Other values are include "random"
# or the FQCN of a custom class
# that implements
# LoadBalancingRpcClient$HostSelector
batch-size = 100 # Must be >=1 (default: 100)
connect-timeout = 20000 # Must be >=1000 (default: 20000)
request-timeout = 20000 # Must be >=1000 (default: 20000)
```
### 嵌入式节点

Flume支持嵌入式API，把节点嵌入到应用中。这种节点意味着更加轻量级，比如没有source,sink以及channel的概念。EmbeddedAgent对象的put以及putAll方法可以搜集事件，目前仅支持File Channel以及Memory Channel，sink仅支持AvroSink.

配置嵌入式节点与配置普通节点类似。下面是额外的配置：
| 属性名称 | 默认值 | 描述 |
| --- | --- | --- |
| source.type | embedded| 唯一可用的source就是embedded source|
| channel.type | - | 可以是memory或者file，对应的是MemoryChannel以及FileChannel|
|channel.*| - | 配置channelde canshu |
| sinks | - | sink的名称列表|
| sink.type | - | 值必须为avro|
| sink.*| - | sink的配置|
| processor.type| - | 可以使failover或者load_balance，对应的是FailoverSinksProcessor以及LoadBalancingSinkProcessor|
| processor.* | - | 配置processor|
| source.interceptors|-|拦截器的列表|
| source.interceptors.*|-|拦截器配置|

```
Map<String, String> properties = new HashMap<String, String>();
properties.put("channel.type", "memory");
properties.put("channel.capacity", "200");
properties.put("sinks", "sink1 sink2");
properties.put("sink1.type", "avro");
properties.put("sink2.type", "avro");
properties.put("sink1.hostname", "collector1.apache.org");
properties.put("sink1.port", "5564");
properties.put("sink2.hostname", "collector2.apache.org");
properties.put("sink2.port", "5565");
properties.put("processor.type", "load_balance");
properties.put("source.interceptors", "i1");
properties.put("source.interceptors.i1.type", "static");
properties.put("source.interceptors.i1.key", "key1");
properties.put("source.interceptors.i1.value", "value1");
EmbeddedAgent agent = new EmbeddedAgent("myagent");
agent.configure(properties);
agent.start();
List<Event> events = Lists.newArrayList();
events.add(event);
events.add(event);
events.add(event);
events.add(event);
agent.putAll(events);
...
agent.stop();
```

## 事务接口

Transaction接口是Flume可靠性的基础。所有的组件（source,sink以及channel）都需要使用transaction。

一个Transaction是通过channel实现的。每个source以及都需要连接channel，但是不包括transaction对象。source实际上是使用channelSelector接口实现Transaction.Event的存储以及消费都在一个Transaction活动中。比如:
```
Channel ch = new MemoryChannel();
Transaction txn = ch.getTransaction();
txn.begin();
try {
// This try clause includes whatever Channel operations you want to do
Event eventToStage = EventBuilder.withBody("Hello Flume!",
Charset.forName("UTF-8"));
ch.put(eventToStage);
// Event takenEvent = ch.take();
// ...
txn.commit();
} catch (Throwable t) {
txn.rollback();
// Log exception, handle individual exceptions as needed
// re-throw all Errors
if (t instanceof Error) {
throw (Error)t;
}
} finally {
txn.close();
}
```
这里仅仅给出存储的例子。在begin()返回后，Transaction开启，并且当Event进入到channel后，如果存储成功，则Transaction提交并且关闭。

### sink

sink从channel中取出event，然后转发给下一个节点或者存储在外部的存储点。一个sink与一个channel协同工作，在FLume的配置文件中设置。有一个SinkRunner实例会管理每个配置的sink,当flume 框架调用sinkRunner.start()方法的时候，新的线程将会开启用于扮演sink的角色（使用sinkRunner.PollingRunner作为线程的Runable）.这个线程管理了sink的生命周期。sink需要实现start()以及stop()方法，作为LifecycleAware接口的一部分。Sink.start()方法用于初始化sink，并切换到可以处理Event的状态。Sink.process()方法负责把channel中的数据取出提取Event事件。Sink.stop()方法则负责必要的清理工作（释放资源）。sink通过实现configurable接口，也可以自行进行一些配置。
```
public class MySink extends AbstractSink implements Configurable {
private String myProp;
@Override
public void configure(Context context) {
String myProp = context.getString("myProp", "defaultValue");
// Process the myProp value (e.g. validation)
// Store myProp for later retrieval by process() method
this.myProp = myProp;
}
@Override
public void start() {
// Initialize the connection to the external repository (e.g. HDFS) that
// this Sink will forward Events to ..
}
@Override
public void stop () {
// Disconnect from the external respository and do any
// additional cleanup (e.g. releasing resources or nulling-out
// field values) ..
}
@Override
public Status process() throws EventDeliveryException {
Status status = null;
// Start transaction
Channel ch = getChannel();
Transaction txn = ch.getTransaction();
txn.begin();
try {
// This try clause includes whatever Channel operations you want to do
Event event = ch.take();
// Send the Event to the external repository.
// storeSomeData(e);
txn.commit();
status = Status.READY;
} catch (Throwable t) {
txn.rollback();
// Log exception, handle individual exceptions as needed
status = Status.BACKOFF;
// re-throw all Errors
if (t instanceof Error) {
throw (Error)t;
}
} finally {
txn.close();
}
return status;
}
}
```

### Source

source目的是从外部的客户端或者channel中获取Event对象。一个source可以是一个ChannelProcessor的实例来产生event。ChannelProcessor可以通过channelSeletor获得实例。Transaction也可以保证source与channel之间的可靠性。

与sinkRunner.PollingRunner的Runable类似，PollingRunner Runable可以通过PollableSourceRunner.start()创建。

注意实际上有两个source，PollableSource是准备阶段。另一个是EventDrivenSource。它具有回调机制。
```
public class MySource extends AbstractSource implements Configurable, PollableSource
private String myProp;
@Override
public void configure(Context context) {
String myProp = context.getString("myProp", "defaultValue");
// Process the myProp value (e.g. validation, convert to another type, ...)
// Store myProp for later retrieval by process() method
this.myProp = myProp;
}
@Override
public void start() {
// Initialize the connection to the external client
}
@Override
public void stop () {
// Disconnect from external client and do any additional cleanup
// (e.g. releasing resources or nulling-out field values) ..
}
@Override
public Status process() throws EventDeliveryException {
Status status = null;
// Start transaction
Channel ch = getChannel();
Transaction txn = ch.getTransaction();
txn.begin();
try {
// This try clause includes whatever Channel operations you want to do
// Receive new data
Event e = getSomeData();
// Store the Event into this Source's associated Channel(s)
getChannelProcessor().processEvent(e)
txn.commit();
status = Status.READY;
} catch (Throwable t) {
txn.rollback();
// Log exception, handle individual exceptions as needed
status = Status.BACKOFF;
// re-throw all Errors
if (t instanceof Error) {
throw (Error)t;
}
} finally {
txn.close();
}
return status;
}
```
