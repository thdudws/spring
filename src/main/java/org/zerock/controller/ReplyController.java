package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criterial;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/replies/")
@Log4j
@RequiredArgsConstructor
public class ReplyController {

	private final ReplyService service;

	//http://localhost:8080/replies/new -> json 데이터를 replyvo 객체로 convert 후 DB에 저장
	//저장 성공이면 ResponseEntity에 "success" 문자열과 상태코드(200)을 응답해준다
	//실패면 ResponseEntity에 상태코드(500) 응답
	@PreAuthorize("isAuthenticated()")	//직접 치고 들어가는 걸 막는다
	@PostMapping(value = "/new", 
			consumes = MediaType.APPLICATION_JSON_VALUE, //요청(json)
			produces = MediaType.TEXT_PLAIN_VALUE)	//응답(string)
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("create......." + vo);
		
		int insertcount = service.register(vo);
		
		//삼항 연산자 처리
		return insertcount == 1 
				? new ResponseEntity<String>("success",HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	};
	
	//http://localhost:8080/replies/pages/5/1 
	//=> reply 테이블에서 bno 5번 전체 레코드 중 1page에 해당하는 10개 가져와라
	@GetMapping(value = "/pages/{bno}/{page}", produces = {
			MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("bno") Long bno, @PathVariable("page") int page
			){
		log.info("getList........bno : " + bno + ", page : " + page);
		
		Criterial cri = new Criterial(page, 10);
		
//		List<ReplyVO> list = service.getList(cri, bno);
		ReplyPageDTO list = service.getListPage(cri, bno);
		
		return new ResponseEntity<ReplyPageDTO>(list, HttpStatus.OK);
	}
	
	//http://localhost:8080/replies/39
	//저장 성공이면 ResponseEntity에 "success" 문자열과 상태코드(200)을 응답해준다
	//실패면 ResponseEntity에 상태코드(500) 응답
	
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value = "/{rno}", 
			consumes = MediaType.APPLICATION_JSON_VALUE,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
		log.info("remove....." + rno);
		
		log.info(rno);
		
		return service.remove(rno) == 1
				? new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//http://localhost:8080/replies/31 -> 31번 레코드 json으로 응답
	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get.........." + rno);
		
		ReplyVO replyVO = service.get(rno);
		
		return new ResponseEntity<ReplyVO>(replyVO, HttpStatus.OK);
	}
	
	//http://localhost:8080/replies/37 + json데이터 => rno(37번) 수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = MediaType.APPLICATION_JSON_VALUE, //요청
			produces = MediaType.TEXT_PLAIN_VALUE) //응답
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo, 
			@PathVariable("rno") Long rno){
		
		vo.setRno(rno);
		
		log.info("modify : " + rno + ", reply : " + vo);
		
		return service.modify(vo) == 1
				? new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	
	
}






