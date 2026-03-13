package com.agriprice.models;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class PriceEntry {

    private int       entryId;
    private int       productId;
    private int       marketId;
    private int       recordedBy;
    private BigDecimal price;
    private Date      priceDate;
    private String    notes;
    private Timestamp createdAt;

    // Extra fields for display (JOIN results)
    private String productName;
    private String marketName;
    private String recorderName;
    private String unit;

    public PriceEntry() {}

    // Getters and Setters
    public int        getEntryId()      { return entryId; }
    public void       setEntryId(int v) { this.entryId = v; }

    public int        getProductId()      { return productId; }
    public void       setProductId(int v) { this.productId = v; }

    public int        getMarketId()      { return marketId; }
    public void       setMarketId(int v) { this.marketId = v; }

    public int        getRecordedBy()      { return recordedBy; }
    public void       setRecordedBy(int v) { this.recordedBy = v; }

    public BigDecimal getPrice()            { return price; }
    public void       setPrice(BigDecimal v){ this.price = v; }

    public Date       getPriceDate()      { return priceDate; }
    public void       setPriceDate(Date v){ this.priceDate = v; }

    public String     getNotes()        { return notes; }
    public void       setNotes(String v){ this.notes = v; }

    public Timestamp  getCreatedAt()          { return createdAt; }
    public void       setCreatedAt(Timestamp v){ this.createdAt = v; }

    public String getProductName()        { return productName; }
    public void   setProductName(String v){ this.productName = v; }

    public String getMarketName()        { return marketName; }
    public void   setMarketName(String v){ this.marketName = v; }

    public String getRecorderName()        { return recorderName; }
    public void   setRecorderName(String v){ this.recorderName = v; }

    public String getUnit()        { return unit; }
    public void   setUnit(String v){ this.unit = v; }
}
