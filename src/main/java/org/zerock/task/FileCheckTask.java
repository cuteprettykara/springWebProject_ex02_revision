package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.controller.UploadController;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterday() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
	
	
	@Scheduled(cron = "0 0/10 * * * *")
	public void checkFiles() {
		log.warn("File Check Task run ..........................");
		log.warn("==============================================");
		log.warn(new Date());
		log.warn("==============================================");
		
		// list file in DB
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// ready for check file in directory with DB file list
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get(UploadController.UPLOAD_FOLDER + vo.getUploadPath() + File.separator 
						+ vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		// image file has thumbnail file
		fileList.stream().filter(vo -> vo.isFileType() == true)
				.map(vo -> Paths.get(UploadController.UPLOAD_FOLDER + vo.getUploadPath() + File.separator 
						+ "s_" + vo.getUuid() + "_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));
		
		fileListPaths.forEach(p -> log.warn(p));
		
		log.warn("==============================================");

		
		
		
		// files in yesterday directory
		File targetDir = Paths.get(UploadController.UPLOAD_FOLDER + getFolderYesterday()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
		log.warn("==============================================");
	}
}
