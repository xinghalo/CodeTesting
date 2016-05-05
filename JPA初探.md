> JPA(java persistence api)，即Java持久化API。通过注解或者XML配置数据库中的对象与应用内存中实体的对应关系。

常见的JPA如：

- JBOSS中使用的Hibernate
- Oracle的Weblogic中使用的TopLink
- IBM的Websphere以及SUN的Glassfish使用的OpenJPA

Spring的JPA：

- 配置文件更灵活
- 实现部分EJB的执行环境下才能使用的功能
- 统一管理EntityManager的创建、销毁、事务管理等。

SpringData主要用于简化业务逻辑接口。

依赖的Jar包：Spring-data-commons以及Spring-data-jpa

Spring Data JPA步骤：

- 1 声明持久化接口，需要继承Repository (CrudRepository会自动创建增删改查)
- 2 声明业务方法
- 3 在Spring配置中，指定base-package

Spring Data 通过方法名创建查询：

首先会剔除一些关键字，如findby等等。然后按照POJO规范，解析属性名称。

```
And --- 等价于 SQL 中的 and 关键字，比如 findByUsernameAndPassword(String user, Striang pwd)；
Or --- 等价于 SQL 中的 or 关键字，比如 findByUsernameOrAddress(String user, String addr)；
Between --- 等价于 SQL 中的 between 关键字，比如 findBySalaryBetween(int max, int min)；
LessThan --- 等价于 SQL 中的 "<"，比如 findBySalaryLessThan(int max)；
GreaterThan --- 等价于 SQL 中的">"，比如 findBySalaryGreaterThan(int min)；
IsNull --- 等价于 SQL 中的 "is null"，比如 findByUsernameIsNull()；
IsNotNull --- 等价于 SQL 中的 "is not null"，比如 findByUsernameIsNotNull()；
NotNull --- 与 IsNotNull 等价；
Like --- 等价于 SQL 中的 "like"，比如 findByUsernameLike(String user)；
NotLike --- 等价于 SQL 中的 "not like"，比如 findByUsernameNotLike(String user)；
OrderBy --- 等价于 SQL 中的 "order by"，比如 findByUsernameOrderBySalaryAsc(String user)；
Not --- 等价于 SQL 中的 "！ ="，比如 findByUsernameNot(String user)；
In --- 等价于 SQL 中的 "in"，比如 findByUsernameIn(Collection<String> userList) ，方法的参数可以是 Collection 类型，也可以是数组或者不定长参数；
NotIn --- 等价于 SQL 中的 "not in"，比如 findByUsernameNotIn(Collection<String> userList) ，方法的参数可以是 Collection 类型，也可以是数组或者不定长参数；
```

使用@query注解查询

## 参考：

1 [博客园-了解Spring Data JPA](http://www.cnblogs.com/WangJinYang/p/4257383.html)
2 [Spring Data JPA官方文档](http://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
