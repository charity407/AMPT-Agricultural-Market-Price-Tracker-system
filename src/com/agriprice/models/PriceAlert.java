package com.agriprice.models;

import java.math.BigDecimal;

public class PriceAlert {

    private int        alertId;
    private int        userId;
    private int        productId;
    private Integer    marketId;   // Integer (not int) because it can be NULL
    private String     alertType;  // "ABOVE" or "BELOW"
    private BigDecimal threshold;
    private boolean    isActive;

    // Extra fields for display
    private String productName;
    private String marketName;
    private String userName;

    public PriceAlert() {}

    public int        getAlertId()        { return alertId; }
    public void       setAlertId(int v)   { this.alertId = v; }

    public int        getUserId()         { return userId; }
    public void       setUserId(int v)    { this.userId = v; }

    public int        getProductId()      { return productId; }
    public void       setProductId(int v) { this.productId = v; }

    public Integer    getMarketId()         { return marketId; }
    public void       setMarketId(Integer v){ this.marketId = v; }

    public String     getAlertType()        { return alertType; }
    public void       setAlertType(String v){ this.alertType = v; }

    public BigDecimal getThreshold()            { return threshold; }
    public void       setThreshold(BigDecimal v){ this.threshold = v; }

    public boolean    isActive()           { return isActive; }
    public void       setActive(boolean v) { this.isActive = v; }

    public String getProductName()        { return productName; }
    public void   setProductName(String v){ this.productName = v; }

    public String getMarketName()        { return marketName; }
    public void   setMarketName(String v){ this.marketName = v; }

    public String getUserName()        { return userName; }
    public void   setUserName(String v){ this.userName = v; }
}
