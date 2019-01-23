package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updatedDate;

	private int replyCnt;

	private List<BoardAttachVO> attachList;
	
	
//	public void setContent(String source) {
//		 this.content = convertHtmlSpecialChars(source);
//	}
	
	
//	private String convertHtmlSpecialChars(String source) {
//
//		StringBuilder sb = new StringBuilder();
//		for (int i = 0; i < source.length(); i++) {
//			char c = source.charAt(i);
//			switch (c) {
//			case '<':
//				sb.append("&lt;");
//				break;
//			case '>':
//				sb.append("&gt;");
//				break;
//			case '&':
//				sb.append("&amp;");
//				break;
//			case '"':
//				sb.append("&quot;");
//				break;
//			case '\'':
//				sb.append("&apos;");
//				break;
//			default:
//				sb.append(c);
//			}
//		}
//
//		return sb.toString();
//	}
//	
}
