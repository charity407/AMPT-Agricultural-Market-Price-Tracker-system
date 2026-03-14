package com.agriprice.models;

public class Product {
    private int productId;
    private String productName;
    private String localName;
    private int categoryId;
    private String standardUnit;
    private boolean isActive;
    private String dateAdded;

    public Product() { this.isActive = true; }

    public boolean isValid() {
        if (productName == null || productName.trim().isEmpty()) return false;
        if (standardUnit == null || standardUnit.trim().isEmpty()) return false;
        if (categoryId <= 0) return false;
        return true;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getLocalName() { return localName; }
    public void setLocalName(String localName) { this.localName = localName; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getStandardUnit() { return standardUnit; }
    public void setStandardUnit(String standardUnit) { this.standardUnit = standardUnit; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public String getDateAdded() { return dateAdded; }
    public void setDateAdded(String dateAdded) { this.dateAdded = dateAdded; }
}