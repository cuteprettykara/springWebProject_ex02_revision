package org.zerock.service;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:webapp/WEB-INF/spring/root-context.xml")
public class SampleServiceTest {
	
	@Setter(onMethod_ = @Autowired)
	private SampleService service;
	
	@Test
	public void testService() throws Exception {
		log.info(service);
		log.info(service.getClass().getName());
	}

	@Test
	public void testAdd() throws Exception {
		Integer actual = service.doAdd("111", "222");
		log.info(actual);
		assertThat(actual, is(333));
	}
	
	@Test(expected = Exception.class)
	public void testAddError() throws Exception {
		service.doAdd("111", "ABC");
	}

}
