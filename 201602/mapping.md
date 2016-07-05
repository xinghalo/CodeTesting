```
{
	"template" : "test-tttt*",
	"mappings" : {
		"_default_" : {
			"properties" : {
				"referrer" : {"type":"string","index":"analyzed"},
				"agent" : {"type":"string","index":"analyzed"},
				"auth" : {"type":"string","index":"analyzed"},
				"ident" : {"type":"string","index":"analyzed"},
				"response" : {"type":"integer","index":"not_analyzed"},
				"bytes" : {"type":"integer","index":"not_analyzed"},
				"clientip" : {"type":"ip","index":"not_analyzed"},
				"rawrequest" : {"type":"string","index":"analyzed"},
				"timestamp" : {"type":"string","index":"analyzed"}
}
}
}
}
```

```
package com.neusoft.dataInsight.collector.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import com.neusoft.dataInsight.collector.entity.SourcetypeEntity;
import com.neusoft.dataInsight.collector.kernel.Constant;
import com.neusoft.dataInsight.collector.kernel.fieldMappings.MappingUnit;
@Service("mappingTemplateManager")
public class MappingTemplateMananger implements ApplicationContextAware,ITempTemplateManager {
	private static Logger logger = LoggerFactory.getLogger(LocalTempFileManager.class);

	@Autowired
	private ISourcetypeService sourcetypeService;
	
	private ApplicationContext ctx;
	private String APP_BASE_PATH = null;
	private String TEMP_DIR_PATH = "WEB-INF/temporary-templates";
	private File temporaryFileDir = null;
	/*{
		  "template" : "loginsight-*",
		  "mappings" : {
		    "_default_" : {
		      "properties" : {
		        "ip" : {"type" : "ip"}
		      }
		    }
		  }
		}*/
/*	
	public String createTemplate(SourcetypeEntity sourcetype,Boolean isTest){
		return null;
	}*/
	
	/**
	 * 传入sourcetype以及索引模式
	 * 
	 * @param sourcetype'
	 * @param isTest
	 * 
	 * @return 模板文件的路径
	 */
	public String createMappingTemplate(SourcetypeEntity sourcetype,Boolean isTest) {
		StringBuilder sb = new StringBuilder();
		sb.append("{\n");
		if(isTest){
			sb.append("	\"template\" : \"test-"+sourcetype.getName()+"*\",\n");
		}else{
			sb.append("	\"template\" : \""+sourcetype.getName()+"-*\",\n");
		}
		sb.append("	\"mappings\" : {\n");
		sb.append("		\"_default_\" : {\n");
		sb.append("			\"properties\" : {\n");
		//********************************生成属性   start***********************************************
		Map<String,MappingUnit> fieldsMapping = sourcetypeService.buildFieldMappings(sourcetype.getFieldMappings()).getMapping();
		List<String> propList = new ArrayList<>();
		for(String key : fieldsMapping.keySet()){
			MappingUnit mapping = fieldsMapping.get(key);
			if(mapping.getType().equals(Constant.OBJECT_TYPE) || mapping.getType().equals(Constant.NESTED_TYPE)){
				//TODO
				//嵌套类型生成配置
			}else{
				propList.add("				\""+key+"\" : {\"type\":\""+mapping.getType()+"\",\"index\":\""+mapping.getParam("index")+"\"}");
			}
		}
		StringBuilder propString = new StringBuilder();
		for(int i=0;i<propList.size()-1;i++){
			propString.append( propList.get(i)+",\n");
		}
		if(propList.size()>0){
			propString.append(propList.get(propList.size()-1)+"\n");
		}
		
		sb.append(propString);
		//********************************生成属性  end***********************************************
		sb.append(			"}\n");
		sb.append(		"}\n");
		sb.append(	"}\n");
		sb.append("}\n");
		logger.debug("Template is created!");
		logger.debug(sb.toString());
		File tempFile;
		if(isTest){
			tempFile = new File(temporaryFileDir, sourcetype.getName()+"-test-template.conf");
		}else{
			tempFile = new File(temporaryFileDir, sourcetype.getName()+"-template.conf");
		}
		try {
			FileUtils.touch(tempFile);
			FileUtils.writeStringToFile(tempFile, sb.toString(), "utf-8", false);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		return tempFile.getAbsolutePath();
	}
	
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.ctx = applicationContext;
		try {
			this.APP_BASE_PATH = this.ctx.getResource("/").getURI().getPath();
		} catch (IOException e) {
			String errMsg = "Failed to get application home path";
			logger.error(errMsg, e);
			throw new RuntimeException(errMsg, e);
		}
		File tempDir = new File(APP_BASE_PATH + TEMP_DIR_PATH);
		if (tempDir.exists()) {
			if (tempDir.isDirectory()) {
				try {
					logger.info("Temporary tempaltes Directory '{}' already exist. Try to clean it...",tempDir.getAbsolutePath());
					FileUtils.cleanDirectory(tempDir);
				} catch (IOException e) {
					logger.error("Error occurred when cleaning the Temporary Files Directory",e);
				}
			} else {
				try {
					logger.info("File '{}' is invalid. Try to delete it..",tempDir.getAbsolutePath());
					FileUtils.forceDelete(tempDir);
				} catch (IOException e) {
					logger.error("Error occurred when delete the invalid File",e);
					throw new RuntimeException(e);
				}
				tempDir.mkdir();
			}
		} else
			tempDir.mkdir();

		temporaryFileDir = tempDir;
		logger.info("The Temporary Template Directory '{}' is created successfully.",temporaryFileDir.getAbsolutePath());
		
	}
}

```
