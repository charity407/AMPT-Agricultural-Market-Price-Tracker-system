# AgriPrice KE — Color Palette

Official color palette for the AgriPrice Agricultural Market Price Tracker system.

## Primary Colors

### Primary Green (Agricultural Theme)
- **Color**: Agricultural Green
- **Hex**: `#2d5016`
- **RGB**: `rgb(45, 80, 22)`
- **Usage**: Main brand color, primary buttons, navigation, headers
- **Contrast**: ✅ WCAG AA compliant with white text

### Secondary Orange (Market/Activity)
- **Color**: Market Orange
- **Hex**: `#ff9500`
- **RGB**: `rgb(255, 149, 0)`
- **Usage**: Call-to-action buttons, highlights, important alerts
- **Contrast**: ✅ WCAG AA compliant with dark text

### Accent Blue (Information & CTAs)
- **Color**: Information Blue
- **Hex**: `#0066cc`
- **RGB**: `rgb(0, 102, 204)`
- **Usage**: Links, secondary CTAs, info messages
- **Contrast**: ✅ WCAG AA compliant with white text

## Neutral Colors

### Light Gray (Backgrounds)
- **Hex**: `#f5f5f5`
- **RGB**: `rgb(245, 245, 245)`
- **Usage**: Background, cards, panels, empty states

### Medium Gray (Secondary Text)
- **Hex**: `#999999`
- **RGB**: `rgb(153, 153, 153)`
- **Usage**: Secondary text, helper text, disabled states
- **Contrast**: ✅ WCAG AA with light backgrounds

### Dark Gray (Primary Text)
- **Hex**: `#333333`
- **RGB**: `rgb(51, 51, 51)`
- **Usage**: Primary text, headings, body copy
- **Contrast**: ✅ WCAG AAA with light backgrounds

### White
- **Hex**: `#ffffff`
- **RGB**: `rgb(255, 255, 255)`
- **Usage**: Text on dark backgrounds, card backgrounds

## Semantic Colors

### Success (Green)
- **Hex**: `#28a745`
- **RGB**: `rgb(40, 167, 69)`
- **Usage**: Success messages, confirmed actions, positive indicators

### Warning (Yellow)
- **Hex**: `#ffc107`
- **RGB**: `rgb(255, 193, 7)`
- **Usage**: Warning messages, caution alerts, pending states
- **Note**: Text color must be dark for accessibility

### Error (Red)
- **Hex**: `#dc3545`
- **RGB**: `rgb(220, 53, 69)`
- **Usage**: Error messages, destructive actions, validation failures

### Info (Cyan)
- **Hex**: `#17a2b8`
- **RGB**: `rgb(23, 162, 184)`
- **Usage**: Informational messages, help text, neutral alerts

## Disabled & Inactive States

### Disabled Elements
- **Background**: `#e9ecef` (very light gray)
- **Text**: `#6c757d` (medium gray)
- **Border**: `#dee2e6` (light border)
- **Opacity**: 50% when layering over colored elements

## CSS Variables

Add these to your CSS stylesheet for consistent theming:

```css
:root {
  /* Primary Colors */
  --color-primary: #2d5016;      /* Agricultural Green */
  --color-secondary: #ff9500;    /* Market Orange */
  --color-accent: #0066cc;       /* Accent Blue */

  /* Neutrals */
  --color-light: #f5f5f5;        /* Light Gray */
  --color-medium: #999999;       /* Medium Gray */
  --color-dark: #333333;         /* Dark Gray */
  --color-white: #ffffff;        /* White */

  /* Semantic */
  --color-success: #28a745;      /* Success Green */
  --color-warning: #ffc107;      /* Warning Yellow */
  --color-error: #dc3545;        /* Error Red */
  --color-info: #17a2b8;         /* Info Cyan */

  /* States */
  --color-disabled-bg: #e9ecef;
  --color-disabled-text: #6c757d;
  --color-disabled-border: #dee2e6;
}
```

## Usage Examples

### Buttons

**Primary Button**
- Background: `--color-primary` (#2d5016)
- Text: `--color-white` (#ffffff)
- Hover: Darken primary by 10%

**Secondary Button**
- Background: `--color-secondary` (#ff9500)
- Text: `--color-dark` (#333333)
- Hover: Darken secondary by 10%

**Danger Button**
- Background: `--color-error` (#dc3545)
- Text: `--color-white` (#ffffff)

**Disabled Button**
- Background: `--color-disabled-bg`
- Text: `--color-disabled-text`
- Opacity: 0.5

### Text Colors

- **Headings**: `--color-dark` (#333333)
- **Body Text**: `--color-dark` (#333333)
- **Secondary Text**: `--color-medium` (#999999)
- **Links**: `--color-accent` (#0066cc)
- **Link Hover**: `--color-primary` (#2d5016)

### Backgrounds

- **Page Background**: `--color-white` (#ffffff)
- **Card Background**: `--color-white` (#ffffff)
- **Section Background**: `--color-light` (#f5f5f5)
- **Panel Background**: `--color-light` (#f5f5f5)

### Alerts

- **Success Alert**: Background `#d4edda`, Text `#155724`
- **Warning Alert**: Background `#fff3cd`, Text `#856404`
- **Error Alert**: Background `#f8d7da`, Text `#721c24`
- **Info Alert**: Background `#d1ecf1`, Text `#0c5460`

## Accessibility Notes

✅ All primary color combinations meet **WCAG 2.1 AA** standards for contrast.

**Minimum Contrast Ratios:**
- Normal text: 4.5:1
- Large text (18px+): 3:1
- UI Components: 3:1

**Testing:**
- Use WebAIM contrast checker: https://webaim.org/resources/contrastchecker/
- Verify all text/background combinations before implementation

## Dark Mode (Future Enhancement)

Reserved color mappings for future dark mode support:

```css
@media (prefers-color-scheme: dark) {
  --color-primary: #5cd65c;      /* Lighter green for dark */
  --color-dark: #e0e0e0;         /* Light text on dark */
  --color-light: #2a2a2a;        /* Dark background */
}
```

---

*AgriPrice KE Color Palette v1.0*
*Last Updated: March 29, 2026*
