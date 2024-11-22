package org.zerock.controller;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.WebApplicationContext;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
@WebAppConfiguration
public class BoardControllerTests {

	@Autowired	//생성자 대신
	private WebApplicationContext ctx;

	private MockMvc mockmvc;
	
	@Before
	public void setup() {
		this.mockmvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void testList() throws Exception {
		log.info(
				mockmvc.perform(MockMvcRequestBuilders.get("/board/list"))	
				.andReturn()
				.getModelAndView()
				.getModelMap()
			);
	}
	
	@Test
	public void testRegister() throws Exception{
		
		String resultPage = mockmvc.perform(MockMvcRequestBuilders.post("/board/register")
				.param("title", "테스트 새 글 제목")
				.param("content", "테스트 새 글 내용")
				.param("writer", "user01"))
			.andReturn().getModelAndView().getViewName();
		
		log.info("resultPage" + resultPage);
		
	}
	
	@Test
	public void testGet() throws Exception {

		ModelMap modelMap = mockmvc.perform(MockMvcRequestBuilders.get("/board/get")
				.param("bno", "5"))
			.andReturn()
			.getModelAndView()
			.getModelMap();
		
		log.info("modelMap : " + modelMap);
		
	}
	
	@Test
	public void testRemove() throws Exception {

		String msg = mockmvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "9"))
				.andReturn()
				.getModelAndView()
				.getViewName();
		
		log.info("msg : " + msg);
		
	}
	
	
}
