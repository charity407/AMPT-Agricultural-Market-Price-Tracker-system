package com.agriprice.models;

public class Market {
    private int marketId;
    private String marketName;
    private String physicalAddress;
    private String town;
    private String country;
    private double latitude;
    private double longitude;
    private String operatingDays;
    private String operatingHours;
    private String status;
    private String dateRegistered;
    private int regionId;

    public Market() { this.country = "KEN"; this.status = "ACTIVE"; }

    public boolean isValid() {
        if (marketName == null || marketName.trim().isEmpty()) return false;
        if (town == null || town.trim().isEmpty()) return false;
        if (regionId <= 0) return false;
        if (status != null && !status.equals("ACTIVE") && !status.equals("INACTIVE")) return false;
        return true;
    }

    public int getMarketId() { return marketId; }
    public void setMarketId(int marketId) { this.marketId = marketId; }
    public String getMarketName() { return marketName; }
    public void setMarketName(String marketName) { this.marketName = marketName; }
    public String getPhysicalAddress() { return physicalAddress; }
    public void setPhysicalAddress(String physicalAddress) { this.physicalAddress = physicalAddress; }
    public String getTown() { return town; }
    public void setTown(String town) { this.town = town; }
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public String getOperatingDays() { return operatingDays; }
    public void setOperatingDays(String operatingDays) { this.operatingDays = operatingDays; }
    public String getOperatingHours() { return operatingHours; }
    public void setOperatingHours(String operatingHours) { this.operatingHours = operatingHours; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDateRegistered() { return dateRegistered; }
    public void setDateRegistered(String dateRegistered) { this.dateRegistered = dateRegistered; }
    public int getRegionId() { return regionId; }
    public void setRegionId(int regionId) { this.regionId = regionId; }
}