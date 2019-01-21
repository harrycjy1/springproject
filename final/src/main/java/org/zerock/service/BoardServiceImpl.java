package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService{
	
		//spring 4.3이상에서 자동 처리
		@Setter(onMethod_=@Autowired)
		private BoardMapper mapper;
		
		@Setter(onMethod_=@Autowired)
		private BoardAttachMapper attachMapper;
		
		@Setter(onMethod_ = @Autowired)
		private ReplyMapper replyMapper;
		
		
		@Transactional
		@Override
		public void register(BoardVO board) {
			
			log.info("register ..........."+ board);
			
			mapper.insertSelectKey(board);
			
			if(board.getAttachList() == null || board.getAttachList().size() <=0) {
				return;
			}
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}

		@Override
		public BoardVO get(Long bno) {
			
			log.info("get............");
			return mapper.read(bno);
		}
		
		@Transactional
		@Override
		public boolean modify(BoardVO board) {
			
			log.info("modify........" + board);
			
			attachMapper.deleteAll(board.getBno()); // 게시물의 첨부파일을 일단 다 지운뒤
			
			boolean modifyResult = mapper.update(board) == 1;
			
			log.info("debugging....."+modifyResult);
			
			if(modifyResult && board.getAttachList() !=null) {
				
				board.getAttachList().forEach(attach -> {
					
					attach.setBno(board.getBno());
					attachMapper.insert(attach); //다시 첨부
				});
			}
			
			
			return modifyResult;
		}

		@Transactional
		@Override
		public boolean remove(Long bno) {
			
			log.info("remove ........" +bno);
			
			attachMapper.deleteAll(bno);
			replyMapper.deleteAll(bno);
			
			
			
			return mapper.delete(bno)==1;
		}

		@Override
		public List<BoardVO> getList(Criteria cri) {
			
			log.info("get List with criteria : " + cri);
			
			return mapper.getListWithPaging(cri);
		}

		@Override
		public int getTotal(Criteria cri) {
			
			log.info("get total count");
			
			return mapper.getTotalCount(cri);
		}

		@Override
		public List<BoardAttachVO> getAttachList(Long bno) {
			
			log.info("get Attach list by bno" + bno);
			
			return attachMapper.findByBno(bno);
		}

		
	
}
