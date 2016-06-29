>Apache Flume是分布式、可靠的、高可用的日志搜集、汇总、传输工具，支持多数据源汇总到同一数据存储位置。
>Apache Flume是Apache组织中的高级项目。目前有两个版本，0.9.x和1.x。本文档是基于1.x的。

# 架构

## 数据流模型

在Flume节点中是以Event为数据单元，Event从`source`经过`channel`交给`sink`，并且实现了Event接口。Event对象携带了payload信息（由一系列的数据以及headers组成，可以理解成一个hash表）。Flume节点是一个JVM的进程，并由一系列的节点组成，使event对象可以从外部的数据源到达目的地。

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
