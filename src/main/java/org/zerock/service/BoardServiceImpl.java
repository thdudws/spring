package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criterial;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardMapper mapper;
	
	@Override
	public void register(BoardVO vo) {
		log.info("register......." + vo);
		mapper.insertSelectKey(vo);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get........");
		
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO vo) {
		log.info("modify..");
		
		//update 성공시 1값 넘어가고 실패하면 0값 넘어온다
		//1값은 트루
		return mapper.update(vo) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove...");
		
		return mapper.delete(bno) == 1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		log.info("List..........");
////		List<BoardVO> list = mapper.getList();
////		return list;
//		
//		return mapper.getList(); 
//	}
	
	@Override
	public List<BoardVO> getList(Criterial cri) {
		log.info("List..........");
//		List<BoardVO> list = mapper.getList();
//		return list;
		
		return mapper.getListWithPaging(cri); 
	}

	@Override
	public int getTotal(Criterial cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

}
