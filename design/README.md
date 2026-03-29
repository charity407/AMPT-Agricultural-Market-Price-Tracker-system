# AgriPrice KE — Design Files

This directory contains all UI/UX design assets, wireframes, mockups, and brand guidelines for the AgriPrice Agricultural Market Price Tracker system.

---

## 📁 Folder Structure

```
design/
├── wireframes/              # UI wireframes (M5)
│   ├── desktop/            # Desktop wireframes (1920px, 1440px, 1024px)
│   └── mobile/             # Mobile wireframes (375px, 414px, 768px)
│
├── mockups/                # High-fidelity mockups (M5/M6)
│   ├── dashboard-admin.fig
│   ├── auth-screens.fig
│   ├── price-entry.fig
│   ├── price-list.fig
│   ├── compare-markets.fig
│   ├── trends-chart.fig
│   ├── alerts-management.fig
│   ├── user-profile.fig
│   └── admin-users-products-markets.fig
│
├── components/             # Reusable UI component library (M5)
│   ├── buttons.fig
│   ├── forms.fig
│   ├── tables.fig
│   ├── modals.fig
│   ├── navigation.fig
│   └── icons.fig
│
├── brand-kit/              # Brand guidelines and assets (M5)
│   ├── agriprice-style-guide.pdf
│   ├── color-palette.md
│   ├── typography.md
│   └── logo-assets/
│
├── responsive/             # Responsive design documentation (M5)
│   ├── breakpoints.md
│   └── responsive-guidelines.md
│
└── guidelines/             # Design guidelines and standards (M5)
    ├── accessibility.md
    ├── design-system.md
    └── component-specs.md
```

---

## 👥 Ownership & Responsibilities

| Area | Owner | Responsibility |
|------|-------|-----------------|
| **Desktop Wireframes** | M5 | Create wireframes for desktop layouts (1024px+) |
| **Mobile Wireframes** | M5 | Create wireframes for mobile layouts (375px-768px) |
| **High-Fidelity Mockups** | M5/M6 | Create detailed mockups in Figma |
| **Component Library** | M5 | Design and document reusable components |
| **Brand Kit & Style Guide** | M5 | Define brand identity, colors, typography |
| **Responsive Breakpoints** | M5 | Document responsive design strategy |
| **Accessibility Guidelines** | M5 | Ensure WCAG 2.1 AA compliance |

---

## 🎨 Design System

### Color Palette
See `brand-kit/color-palette.md` for complete color system.

**Primary Colors:**
- Primary Green: `#2d5016` (Agricultural theme)
- Secondary Orange: `#ff9500` (Market/Activity)
- Accent Blue: `#0066cc` (CTAs and highlights)

**Neutral Colors:**
- Light Gray: `#f5f5f5` (Backgrounds)
- Medium Gray: `#999999` (Secondary text)
- Dark Gray: `#333333` (Primary text)
- White: `#ffffff`

### Typography
See `brand-kit/typography.md` for complete typography system.

**Font Stack:**
- Headings: Segoe UI, Tahoma, sans-serif (Bold 700)
- Body: Segoe UI, Tahoma, sans-serif (Regular 400)
- Monospace: Courier New, monospace (for code)

**Sizes:**
- H1: 32px (bold)
- H2: 24px (bold)
- H3: 18px (bold)
- Body: 14px (regular)
- Caption: 12px (regular)

### Spacing
- Base unit: 8px
- Margins/Padding: 8px, 16px, 24px, 32px
- Gap (flex): 8px, 16px, 24px

### Breakpoints
- **Mobile**: 320px - 375px (iPhone SE, 6, 7, 8)
- **Tablet**: 376px - 768px (iPad Mini, Air)
- **Laptop**: 769px - 1024px (iPad Pro, small laptops)
- **Desktop**: 1025px+ (standard desktops, widescreen)

---

## 📋 File Format Guidelines

### Wireframes
- **Format**: Figma, PDF, PNG
- **Resolution**:
  - Desktop: 1920×1080 (FHD), 1440×900, 1024×768
  - Mobile: 375×667 (iPhone 8), 414×896 (iPhone 13)
- **Naming**: `[page-name]-wireframe-[resolution].fig`
- **Example**: `dashboard-wireframe-1440.fig`

### Mockups
- **Format**: Figma (.fig) as primary, PDF exports for reference
- **Resolution**: High-fidelity (2x pixel density preferred)
- **Naming**: `[page-name]-mockup.fig`
- **Example**: `price-entry-mockup.fig`

### Component Library
- **Format**: Figma components with variants
- **Documentation**: Inline comments in Figma
- **Naming**: Component names must match CSS class names
- **Example**: `btn-primary`, `form-input`, `price-table`

### Brand Kit
- **Color Palette**: Figma color library + Markdown reference
- **Typography**: Google Fonts + CSS variables
- **Logo**: SVG (scalable) + PNG (raster fallback)
- **Icons**: SVG sprite sheet or individual SVG files

---

## 🔗 External Resources

### Figma Design System
- **Main Workspace**: [https://figma.com/...agriprice-ke](https://figma.com)
- **Access**: Shared with M5, M6, M7
- **Components**: Live in Figma, linked to CSS
- **Prototype**: [https://www.figma.com/proto/...](https://www.figma.com/proto/)

### Design Tools Used
- **Figma**: Primary design tool for mockups, wireframes, prototypes
- **Styles**: CSS variables in `WebContent/css/style.css`
- **Icons**: Font Awesome or custom SVG

---

## 📝 File Submission Checklist

Before submitting design files, ensure:

### Wireframes
- [ ] Created at correct resolution(s)
- [ ] Labeled with page names and sections
- [ ] Includes responsive variations
- [ ] Exported as PDF for version control
- [ ] Uploaded to Figma for team collaboration

### Mockups
- [ ] High-fidelity (visual hierarchy clear)
- [ ] Follows brand guidelines exactly
- [ ] All text is final (no lorem ipsum)
- [ ] Interactive elements clearly indicated
- [ ] Responsive versions included (desktop, tablet, mobile)
- [ ] PDF export added to Git for reference
- [ ] Figma file shared with M5, M6, M7

### Components
- [ ] Figma component created with variants
- [ ] CSS class naming matches component name
- [ ] Accessibility features included (ARIA, color contrast)
- [ ] Documentation updated in component specs
- [ ] Implementation guide provided for developers

### Brand Kit
- [ ] Color palette with hex/RGB values
- [ ] Typography specimens and usage rules
- [ ] Logo usage guidelines (clearspace, sizes)
- [ ] Accessibility compliance verified (WCAG 2.1 AA)
- [ ] All assets exported and organized

---

## 🚀 Implementation Workflow

1. **Design Phase** (M5/M6)
   - Create wireframes in Figma
   - Share prototype link with team
   - Gather feedback
   - Create high-fidelity mockups

2. **Review Phase** (M5/M6/M7)
   - Review for accessibility (WCAG 2.1 AA)
   - Verify responsive designs
   - Check brand consistency
   - Approve mockups

3. **Export Phase** (M5/M6)
   - Export high-res PNGs/PDFs
   - Save Figma components
   - Commit to Git

4. **Implementation Phase** (Developer)
   - Review design files
   - Extract CSS variables
   - Implement responsive HTML/JSP
   - Verify against mockups

---

## 🎯 Design Standards

### Accessibility (WCAG 2.1 AA)
- [ ] Color contrast: ≥ 4.5:1 for normal text
- [ ] Touch targets: ≥ 44×44 pixels
- [ ] Keyboard navigation: All interactive elements accessible via keyboard
- [ ] ARIA labels: Meaningful alt text and labels
- [ ] Focus indicators: Visible focus states

### Responsive Design
- [ ] Mobile-first approach
- [ ] Tested at all breakpoints (320px, 375px, 768px, 1024px, 1440px)
- [ ] No horizontal scroll
- [ ] Touch-friendly spacing on mobile
- [ ] Readable font sizes at all scales

### Performance
- [ ] Image optimization: Compressed PNGs/WebP
- [ ] File size: Mockups < 5MB
- [ ] Figma performance: Minimal lag with large files
- [ ] Export quality: Lossless compression

---

## 📞 Contact & Questions

- **Design Lead**: Member 5 (M5)
- **Feature Pages**: Member 6 (M6)
- **QA & Documentation**: Member 7 (M7)

For design file updates or access issues, contact the design lead or create an issue in GitHub.

---

## 🏗️ Placeholder Structure

This folder structure is currently **empty and ready for design files** from Members 5 and 6.

**To be completed by:**
- **Week 1 (Mar 9-15)**: Wireframes and brand guidelines
- **Week 2 (Mar 16-22)**: High-fidelity mockups and component library
- **Week 3 (Mar 23-29)**: Responsive variations and detailed specs
- **Week 4 (Mar 30-Apr 6)**: Final assets and design system documentation

---

*Created: March 29, 2026*
*Last Updated: March 29, 2026*
*Version: 1.0*
