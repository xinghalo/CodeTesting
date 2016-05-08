## Elasticsearch中字段与关键属性

其中需要说明的是：

#### index定义字段的分析类型以及检索方式

- 如果是no，则无法通过检索查询到该字段；
- 如果设置为not_analyzed则会将整个字段存储为关键词，常用于汉字短语、邮箱等复杂的字符串；
- 如果设置为analyzed则将会通过默认的standard分析器进行分析，[详细的分析规则参考这里](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html)

#### store定义了字段是否存储

在《ES IN ACTION》中有这样一段描述：
```
This might be useful when you ask Elasticsearch for a particular field because retrieving a single stored field will be faster than retrieving the entire _source and extracting that field from it, especially when you have large documents.
NOTE When you store individual fields as well, you should take into account that the more you store, the bigger your index gets. Usually bigger indices imply slower indexing and slower searching.
```
意思是，在ES中原始的文本会存储在_source里面（除非你关闭了它）。默认情况下其他提取出来的字段都不是独立存储的，是从_source里面提取出来的。当然你也可以独立的存储某个字段，只要设置store:true即可。

独立存储某个字段，在频繁使用某个特殊字段时很常用。而且获取独立存储的字段要比从_source中解析快得多，而且额外你还需要从_source中解析出来这个字段，尤其是_source特别大的时候。

不过需要注意的是，独立存储的字段越多，那么索引就越大；索引越大，索引和检索的过程就会越慢....

## string

字符串类型，es中最常用的类型，[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/string.html)

比较重要的参数：
##### index分析
- analyzed(默认)
- not_analyzed
- no
##### store存储
- true 独立存储
- false（默认）不存储，从_source中解析

## Numeric

数值类型，注意numeric并不是一个类型，它包括多种类型，比如：long,integer,short,byte,double,float，每种的存储空间都是不一样的，一般默认推荐integer和float。[官方文档参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/number.html)

重要的参数：
##### index分析
- not_analyzed(默认) ，设置为该值可以保证该字段能通过检索查询到
- no
##### store存储
- true 独立存储
- false（默认）不存储，从_source中解析

## date 

日期类型，该类型可以接受一些常见的日期表达方式，[官方文档参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/date.html)。

重要的参数：
##### index分析
- not_analyzed(默认) ，设置为该值可以保证该字段能通过检索查询到
- no
##### store存储
- true 独立存储
- false（默认）不存储，从_source中解析
##### format格式化
- strict_date_optional_time||epoch_millis（默认）
- 你也可以自定义格式化内容，比如
```
"date": {
  "type":   "date",
  "format": "yyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
}
```
- [更多的时间表达式可以参考这里](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-date-format.html#strict-date-time)

## IP

这个类型可以用来标识IPV4的地址，[参考官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/ip.html)

常用参数：
##### index分析
- not_analyzed(默认) ，设置为该值可以保证该字段能通过检索查询到
- no
##### store存储
- true 独立存储
- false（默认）不存储，从_source中解析

## boolean

布尔类型，所有的类型都可以标识布尔类型，[参考官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/boolean.html)

- False: 表示该值的有:false, "false", "off", "no", "0", "" (empty string), 0, 0.0
- True: 所有非False的都是true

重要的参数：
##### index分析
- not_analyzed(默认) ，设置为该值可以保证该字段能通过检索查询到
- no
##### store存储
- true 独立存储
- false（默认）不存储，从_source中解析
