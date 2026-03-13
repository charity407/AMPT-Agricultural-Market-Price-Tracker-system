package com.agriprice.models;

public class Region {
    private int regionId;
    private String regionName;
    private String country;
    private String regionCode;

    public Region() { this.country = "KEN"; }

    public boolean isValid() {
        if (regionName == null || regionName.trim().isEmpty()) return false;
        if (regionCode == null || regionCode.trim().isEmpty()) return false;
        if (regionCode.length() > 10) return false;
        if (!regionCode.matches("[A-Za-z0-9_-]+")) return false;
        return true;
    }

    public int getRegionId() { return regionId; }
    public void setRegionId(int regionId) { this.regionId = regionId; }
    public String getRegionName() { return regionName; }
    public void setRegionName(String regionName) { this.regionName = regionName; }
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    public String getRegionCode() { return regionCode; }
    public void setRegionCode(String regionCode) { this.regionCode = regionCode; }
}