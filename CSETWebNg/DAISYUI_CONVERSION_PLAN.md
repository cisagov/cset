# DaisyUI Conversion Plan

## Overview
Convert CSET from Angular Material + Bootstrap to DaisyUI + Tailwind CSS while maintaining functionality and visual consistency.

## Phase 1: Configuration & Global Styles
- [x] DaisyUI already configured in styles.css
- [ ] Create Tailwind config file with DaisyUI theme customization
- [ ] Update global styles to remove Bootstrap/Angular Material dependencies
- [ ] Configure CSET color palette in DaisyUI theme

## Phase 2: Component Mapping

### Angular Material → DaisyUI Equivalents
- `mat-button` → `btn btn-primary/btn-secondary`
- `mat-dialog` → `modal`
- `mat-menu` → `dropdown`
- `mat-card` → `card`
- `mat-form-field` → `form-control`
- `mat-input` → `input input-bordered`
- `mat-select` → `select select-bordered`
- `mat-checkbox` → `checkbox`
- `mat-radio-button` → `radio`
- `mat-table` → `table`
- `mat-tabs` → `tabs`
- `mat-sidenav` → `drawer`
- `mat-toolbar` → `navbar`
- `mat-progress-bar` → `progress`
- `mat-snack-bar` → `toast` (custom implementation)

### Bootstrap → Tailwind/DaisyUI Classes
- `d-flex` → `flex`
- `justify-content-start` → `justify-start`
- `justify-content-center` → `justify-center`
- `justify-content-end` → `justify-end`
- `align-items-center` → `items-center`
- `flex-column` → `flex-col`
- `btn btn-primary` → `btn btn-primary`
- `container-fluid` → `container max-w-none`
- `col-*` → `w-*` or grid classes
- `mt-*`, `mb-*`, etc. → `mt-*`, `mb-*` (Tailwind)

## Phase 3: Priority Conversion Order

### High Priority (Core Functionality)
1. Layout components (layout-main, top-menus)
2. Button components throughout the app
3. Form components (inputs, selects, checkboxes)
4. Navigation components
5. Modal/Dialog components

### Medium Priority
1. Card components
2. Table components
3. Progress indicators
4. Tabs components

### Low Priority
1. Advanced Material components (expansion panels, etc.)
2. Specialized report styling
3. Custom theme refinements

## Phase 4: Implementation Steps

### Step 1: Create Tailwind Config
- Define CSET color palette
- Configure DaisyUI theme
- Set up custom component styles

### Step 2: Update Global Styles
- Remove Angular Material theme imports
- Remove Bootstrap imports
- Add DaisyUI customizations

### Step 3: Convert Layout Components
- Start with layout-main.component
- Convert top-menus.component
- Update navbar styling  

### Step 4: Convert Core Components
- Update button styles globally
- Convert form components
- Convert modal/dialog components

### Step 5: Systematic Template Updates
- Use find/replace for common Bootstrap → Tailwind conversions
- Update Angular Material component usage
- Test each component after conversion

## Phase 5: Testing & Refinement
- Visual regression testing
- Functionality testing
- Responsive design verification
- Theme consistency check

## Rollback Plan
- Keep original styles commented out initially
- Create feature branch for conversion
- Test thoroughly before merging

## Notes
- DaisyUI provides semantic component classes that are easier to maintain than utility-first Tailwind
- Some Angular Material functionality may need custom JavaScript (like dialogs, snackbars)
- Consider keeping some Angular Material components for complex functionality (date pickers, etc.)