> 在日常的Java程序开发中，Properties文件的读写是很常用的。经常有开发系统通过properties文件来当做配置文件，方便用户对系统参数进行调整。
> 那么本片就来简单的介绍下，如何使用Properties。

## 文件的读取

Properties类提供了Load方法，支持以inputstream为参数，读取配置文件。因此可以这样：
```
Properties props = new Properties();
//如果配置文件放在类目录下，可以直接通过类加载器读取
props.load(new FileReader("D:\\test.properties"));
```
不过上面的读取方法需要完整的文件路径，显然在开发中是很不方便的。
因此推荐下面这种方法，通过类加载器的路径来读取配置文件：
```
props.load(PropertiesTest.class.getClassLoader().getResourceAsStream(fileName));
```

## 属性的读写

通过getProperty可以取到文件的属性：
```
//获取属性值
System.out.println(props.getProperty("name"));
System.out.println(props.getProperty("age"));
System.out.println(props.getProperty("address","dalian"));//如果没有拿到属性值，会按照第二个参数作为默认值
			
//修改属性值
props.setProperty("name", "ttt");
System.out.println(props.getProperty("name"));
```

## 配置持久化

如果需要在程序运行时，持久化配置文件，也可以使用store方法：
```
//持久化配置文件
File file = new File("D:\\result.properties");
Writer fw = new FileWriter(file);
props.store(fw, "conmments");
fw.close();
```
## 源码测试

```
package xing.CodeJava.basic;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.Writer;
import java.util.Properties;


public class PropertiesTest {
	public static void main(String[] args) {
		String fileName = "test.properties";
		try {
			//读取配置文件
			Properties props = new Properties();
//			props.load(PropertiesTest.class.getClassLoader().getResourceAsStream(fileName));//如果配置文件放在类目录下，可以直接通过类加载器读取
			props.load(new FileReader("D:\\TestCode\\CodeJava\\CodeJava\\src\\main\\java\\xing\\CodeJava\\basic\\test.properties"));
			
			//获取属性值
			System.out.println(props.getProperty("name"));
			System.out.println(props.getProperty("age"));
			System.out.println(props.getProperty("address","dalian"));//如果没有拿到属性值，会按照第二个参数作为默认值
			
			//修改属性值
			props.setProperty("name", "ttt");
			System.out.println(props.getProperty("name"));
			
			//持久化配置文件
			File file = new File("D:\\TestCode\\CodeJava\\CodeJava\\src\\main\\java\\xing\\CodeJava\\basic\\result.properties");
			Writer fw = new FileWriter(file);
			props.store(fw, "conmments");
			fw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
```
