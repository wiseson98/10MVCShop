package com.model2.mvc.common;

public class Category {

	/// Field
	private int categoryNo;
	private String categoryName;
	private int categoryLevel;
	private int categoryPrevLevel;
	
	/// Constructor
	public Category() {
	}

	/// Method
	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public int getCategoryLevel() {
		return categoryLevel;
	}

	public void setCategoryLevel(int categoryLevel) {
		this.categoryLevel = categoryLevel;
	}

	public int getCategoryPrevLevel() {
		return categoryPrevLevel;
	}

	public void setCategoryPrevLevel(int categoryPrevLevel) {
		this.categoryPrevLevel = categoryPrevLevel;
	}

	@Override
	public String toString() {
		return "Category [categoryNo=" + categoryNo + ", categoryName=" + categoryName + ", categoryLevel="
				+ categoryLevel + ", categoryPrevLevel=" + categoryPrevLevel + "]";
	}	

}//end of class