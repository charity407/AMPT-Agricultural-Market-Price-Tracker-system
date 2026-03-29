package com.agriprice.models;

public class Category {
    private int categoryId;
    private String categoryName;
    private String categoryType;
    private String eacCode;
    private String description;

    public Category() {}

    public boolean isValid() {
        if (categoryName == null || categoryName.trim().isEmpty()) return false;
        if (categoryType == null) return false;
        switch (categoryType.toUpperCase()) {
            case "CROP": case "LIVESTOCK": case "PRODUCE": case "OTHER": break;
            default: return false;
        }
        return true;
    }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getCategoryType() { return categoryType; }
    public void setCategoryType(String categoryType) { this.categoryType = categoryType; }
    public String getEacCode() { return eacCode; }
    public void setEacCode(String eacCode) { this.eacCode = eacCode; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}