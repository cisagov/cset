import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

// Enhanced interfaces for CSS support
interface CSSStyles {
  fontSize?: number;
  fontFamily?: string;
  fontWeight?: string | number;
  fontStyle?: string;
  textDecoration?: string;
  color?: string;
  backgroundColor?: string;
  textAlign?: string;
  lineHeight?: number;
  marginTop?: number;
  marginBottom?: number;
  marginLeft?: number;
  marginRight?: number;
  paddingTop?: number;
  paddingBottom?: number;
  paddingLeft?: number;
  paddingRight?: number;
  borderColor?: string;
  borderWidth?: number;
  borderStyle?: string;
}

interface StyledElement {
  tagName: string;
  textContent: string;
  styles: CSSStyles;
  children?: StyledElement[];
  attributes?: { [key: string]: string };
}

interface ConversionOptions {
  filename?: string;
  pageSize?: 'A4' | 'Letter' | 'Legal';
  margins?: { top?: number; right?: number; bottom?: number; left?: number };
  orientation?: 'portrait' | 'landscape';
  preserveCSS?: boolean;
  embedFonts?: boolean;
  convertImages?: boolean;
  tableStyles?: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class HtmlToDocxService {
  private readonly http = inject(HttpClient);
  private docxLibrary: any = null;
  private fileSaverLibrary: any = null;
  private isInitialized = false;

  // Initialize libraries with proper error handling
  private async initializeLibraries(): Promise<void> {
    if (this.isInitialized) {
      return;
    }

    try {
      console.log('Initializing DOCX libraries...');
      
      // Method 1: Try dynamic imports with retry logic
      try {
        await this.loadLibrariesDynamically();
      } catch (dynamicError) {
        console.warn('Dynamic import failed, trying alternative method:', dynamicError);
        // Method 2: Try global fallback
        await this.loadLibrariesFromGlobals();
      }

      this.isInitialized = true;
      console.log('Libraries initialized successfully');
      
    } catch (error) {
      console.error('Failed to initialize libraries:', error);
      throw new Error('Failed to load required libraries. Please refresh the page and try again.');
    }
  }

  private async loadLibrariesDynamically(): Promise<void> {
    // Load docx library with timeout
    const docxPromise = Promise.race([
      import('docx'),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('DOCX import timeout')), 10000)
      )
    ]);

    // Load file-saver library with timeout
    const fileSaverPromise = Promise.race([
      import('file-saver'),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('File-saver import timeout')), 5000)
      )
    ]);

    const [docxLib, fileSaverLib] = await Promise.all([docxPromise, fileSaverPromise]);
    
    this.docxLibrary = docxLib;
    this.fileSaverLibrary = fileSaverLib;

    // Validate library functions
    this.validateLibraries();
  }

  private async loadLibrariesFromGlobals(): Promise<void> {
    // Check if libraries are available globally (fallback)
    if (typeof window !== 'undefined') {
      // @ts-ignore
      if (window.docx) {
        // @ts-ignore
        this.docxLibrary = window.docx;
      }
      
      // @ts-ignore
      if (window.saveAs) {
        // @ts-ignore
        this.fileSaverLibrary = { saveAs: window.saveAs };
      }
    }

    if (!this.docxLibrary || !this.fileSaverLibrary) {
      throw new Error('Libraries not available globally');
    }

    this.validateLibraries();
  }

  private validateLibraries(): void {
    // Validate DOCX library
    if (!this.docxLibrary?.Document || 
        !this.docxLibrary?.Paragraph || 
        !this.docxLibrary?.TextRun || 
        !this.docxLibrary?.Packer) {
      throw new Error('DOCX library is incomplete or corrupted');
    }

    // Validate file-saver library
    if (!this.fileSaverLibrary?.saveAs) {
      throw new Error('File-saver library is incomplete or corrupted');
    }

    console.log('Library validation successful');
  }

  // Main conversion method with enhanced error handling
  async convertHtmlToDocx(
    htmlContent: string,
    options: ConversionOptions = { preserveCSS: true }
  ): Promise<void> {
    try {
      console.log('Starting robust conversion...');
      
      // Initialize libraries first
      await this.initializeLibraries();
      
      // Validate input
      if (!htmlContent || htmlContent.trim().length === 0) {
        throw new Error('HTML content is empty or invalid');
      }

      // Parse HTML and extract styles with error boundaries
      const styledElements = await this.safeParseHtmlWithStyles(htmlContent);
      console.log('Parsed styled elements:', styledElements.length);
      
      // Convert to DOCX elements with error handling
      const docxElements = await this.safeConvertToDocx(styledElements);
      console.log('Generated DOCX elements:', docxElements.length);
      
      // Create document using validated library
      const docxDocument = await this.createDocumentSafely(docxElements, options);
      console.log('Document created successfully');
      
      // Generate and save with error recovery
      await this.generateAndSaveDocument(docxDocument, options.filename || 'document.docx');
      console.log('Document saved successfully');

    } catch (error) {
      console.error('Error in robust conversion:', error);
      
      // Enhanced error classification and recovery
      if (error instanceof Error) {
        if (error.message.includes('g is not a function') || 
            error.message.includes('Y is not a function') ||
            error.message.includes('is not a function')) {
          
          // Library initialization error - try to recover
          console.log('Attempting library recovery...');
          this.isInitialized = false;
          this.docxLibrary = null;
          this.fileSaverLibrary = null;
          
          throw new Error('Library initialization failed. Please refresh the page and try again. If the problem persists, try a different browser.');
        } else if (error.message.includes('timeout')) {
          throw new Error('Conversion timed out. Please try with smaller content or check your internet connection.');
        } else if (error.message.includes('Failed to load')) {
          throw new Error('Required libraries could not be loaded. Please check your internet connection and try again.');
        } else {
          throw new Error(`Conversion failed: ${error.message}`);
        }
      } else {
        throw new Error('An unexpected error occurred during conversion. Please try again.');
      }
    }
  }

  // Safe HTML parsing with error boundaries
  private async safeParseHtmlWithStyles(htmlContent: string): Promise<StyledElement[]> {
    try {
      const parser = new DOMParser();
      const doc = parser.parseFromString(htmlContent, 'text/html');
      
      // Check for parsing errors
      const parserErrors = doc.querySelectorAll('parsererror');
      if (parserErrors.length > 0) {
        console.warn('HTML parsing errors detected, using fallback parsing');
        return this.fallbackHtmlParsing(htmlContent);
      }

      const styledElements: StyledElement[] = [];

      const processElement = (element: HTMLElement): StyledElement => {
        try {
          const computedStyle = window.getComputedStyle(element);
          
          // Extract CSS styles with fallbacks
          const styles: CSSStyles = this.extractStyles(computedStyle);

          // Process child elements safely
          const children: StyledElement[] = [];
          const childElements = Array.from(element.children);
          for (const child of childElements) {
            if (child instanceof HTMLElement) {
              try {
                children.push(processElement(child));
              } catch (childError) {
                console.warn('Error processing child element:', childError);
                // Add as simple text element
                children.push({
                  tagName: child.tagName.toLowerCase(),
                  textContent: child.textContent || '',
                  styles: {},
                  children: [],
                  attributes: {}
                });
              }
            }
          }

          return {
            tagName: element.tagName.toLowerCase(),
            textContent: this.getTextContent(element),
            styles,
            children,
            attributes: this.getElementAttributes(element)
          };
        } catch (elementError) {
          console.warn('Error processing element:', elementError);
          return {
            tagName: element.tagName.toLowerCase(),
            textContent: element.textContent || '',
            styles: {},
            children: [],
            attributes: {}
          };
        }
      };

      // Process body elements with error boundaries
      const bodyElements = Array.from(doc.body.children);
      for (const child of bodyElements) {
        if (child instanceof HTMLElement) {
          try {
            styledElements.push(processElement(child));
          } catch (error) {
            console.warn('Error processing top-level element:', error);
            // Add as fallback
            styledElements.push({
              tagName: child.tagName.toLowerCase(),
              textContent: child.textContent || '',
              styles: {},
              children: [],
              attributes: {}
            });
          }
        }
      }

      return styledElements.length > 0 ? styledElements : this.fallbackHtmlParsing(htmlContent);
      
    } catch (error) {
      console.error('Error in safe HTML parsing:', error);
      return this.fallbackHtmlParsing(htmlContent);
    }
  }

  // Fallback HTML parsing for corrupted content
  private fallbackHtmlParsing(htmlContent: string): StyledElement[] {
    console.log('Using fallback HTML parsing');
    
    // Simple text extraction
    const textContent = htmlContent.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
    
    if (!textContent) {
      return [{
        tagName: 'p',
        textContent: 'Content could not be processed',
        styles: {},
        children: [],
        attributes: {}
      }];
    }

    // Split into paragraphs
    const paragraphs = textContent.split(/[.!?]+/).filter(p => p.trim().length > 0);
    
    return paragraphs.map(paragraph => ({
      tagName: 'p',
      textContent: paragraph.trim(),
      styles: { fontSize: 12, fontFamily: 'Arial' },
      children: [],
      attributes: {}
    }));
  }

  // Safe DOCX conversion with error handling
  private async safeConvertToDocx(elements: StyledElement[]): Promise<any[]> {
    if (!this.docxLibrary) {
      throw new Error('DOCX library not initialized');
    }

    const { Document, Paragraph, TextRun, HeadingLevel, AlignmentType, UnderlineType, Table, TableRow, TableCell, BorderStyle, WidthType } = this.docxLibrary;
    
    const docxElements: any[] = [];

    const processElement = async (element: StyledElement): Promise<any[]> => {
      const results: any[] = [];

      try {
        switch (element.tagName) {
          case 'h1':
          case 'h2':
          case 'h3':
          case 'h4':
          case 'h5':
          case 'h6':
            const headingLevel = parseInt(element.tagName.charAt(1));
            const headingLevels = [
              HeadingLevel.HEADING_1,
              HeadingLevel.HEADING_2,
              HeadingLevel.HEADING_3,
              HeadingLevel.HEADING_4,
              HeadingLevel.HEADING_5,
              HeadingLevel.HEADING_6
            ];

            results.push(new Paragraph({
              heading: headingLevels[headingLevel - 1] || HeadingLevel.HEADING_1,
              children: [this.createSafeTextRun(element, TextRun, UnderlineType)],
              alignment: this.getTextAlignment(element.styles.textAlign, AlignmentType),
              spacing: {
                before: this.convertToTwips(element.styles.marginTop || 0),
                after: this.convertToTwips(element.styles.marginBottom || 0)
              }
            }));
            break;

          case 'p':
            const textRuns = this.processSafeInlineElements(element, TextRun, UnderlineType);
            if (textRuns.length > 0) {
              results.push(new Paragraph({
                children: textRuns,
                alignment: this.getTextAlignment(element.styles.textAlign, AlignmentType),
                spacing: {
                  before: this.convertToTwips(element.styles.marginTop || 0),
                  after: this.convertToTwips(element.styles.marginBottom || 0),
                  line: element.styles.lineHeight ? Math.round(element.styles.lineHeight * 240) : undefined
                },
                indent: {
                  left: this.convertToTwips(element.styles.marginLeft || 0),
                  right: this.convertToTwips(element.styles.marginRight || 0)
                }
              }));
            }
            break;

          case 'ul':
          case 'ol':
            if (element.children) {
              for (const child of element.children) {
                if (child.tagName === 'li') {
                  results.push(new Paragraph({
                    bullet: { level: 0 },
                    children: [this.createSafeTextRun(child, TextRun, UnderlineType)],
                    spacing: {
                      before: this.convertToTwips(child.styles.marginTop || 0),
                      after: this.convertToTwips(child.styles.marginBottom || 0)
                    }
                  }));
                }
              }
            }
            break;

          case 'table':
            try {
              const table = await this.createSafeTable(element, Table, TableRow, TableCell, Paragraph, TextRun, UnderlineType, BorderStyle, WidthType);
              if (table) {
                results.push(table);
              }
            } catch (tableError) {
              console.warn('Error creating table, converting to paragraphs:', tableError);
              // Convert table to simple paragraphs
              if (element.children) {
                for (const row of element.children) {
                  if (row.children) {
                    const cellTexts = row.children.map(cell => cell.textContent).join(' | ');
                    if (cellTexts.trim()) {
                      results.push(new Paragraph({
                        children: [new TextRun(cellTexts)]
                      }));
                    }
                  }
                }
              }
            }
            break;

          case 'blockquote':
            results.push(new Paragraph({
              children: [this.createSafeTextRun(element, TextRun, UnderlineType)],
              indent: { left: 720 }, // 0.5 inch
              spacing: {
                before: this.convertToTwips(element.styles.marginTop || 0),
                after: this.convertToTwips(element.styles.marginBottom || 0)
              }
            }));
            break;

          case 'div':
          case 'section':
          case 'article':
            // Process children first
            if (element.children) {
              for (const child of element.children) {
                try {
                  const childResults = await processElement(child);
                  results.push(...childResults);
                } catch (childError) {
                  console.warn('Error processing child element:', childError);
                }
              }
            }
            
            // Add text content if present and no children
            if (element.textContent.trim() && (!element.children || element.children.length === 0)) {
              results.push(new Paragraph({
                children: [this.createSafeTextRun(element, TextRun, UnderlineType)],
                spacing: {
                  before: this.convertToTwips(element.styles.marginTop || 0),
                  after: this.convertToTwips(element.styles.marginBottom || 0)
                }
              }));
            }
            break;

          case 'br':
            results.push(new Paragraph({ children: [new TextRun('')] }));
            break;

          default:
            if (element.textContent.trim()) {
              results.push(new Paragraph({
                children: [this.createSafeTextRun(element, TextRun, UnderlineType)],
                spacing: {
                  before: this.convertToTwips(element.styles.marginTop || 0),
                  after: this.convertToTwips(element.styles.marginBottom || 0)
                }
              }));
            }
        }
      } catch (elementError) {
        console.warn(`Error processing ${element.tagName}:`, elementError);
        // Fallback to simple paragraph
        if (element.textContent.trim()) {
          try {
            results.push(new Paragraph({
              children: [new TextRun(element.textContent)]
            }));
          } catch (fallbackError) {
            console.warn('Even fallback failed:', fallbackError);
          }
        }
      }

      return results;
    };

    // Process all elements with comprehensive error handling
    for (const element of elements) {
      try {
        const elementResults = await processElement(element);
        docxElements.push(...elementResults);
      } catch (error) {
        console.warn('Error processing element:', error);
        // Add fallback paragraph
        try {
          docxElements.push(new Paragraph({
            children: [new TextRun(element.textContent || 'Content could not be processed')]
          }));
        } catch (fallbackError) {
          console.warn('Fallback paragraph creation failed:', fallbackError);
        }
      }
    }

    // Ensure we have at least one element
    if (docxElements.length === 0) {
      docxElements.push(new Paragraph({
        children: [new TextRun('Document content could not be processed')]
      }));
    }

    return docxElements;
  }

  // Safe document creation
  private async createDocumentSafely(docxElements: any[], options: ConversionOptions): Promise<any> {
    if (!this.docxLibrary) {
      throw new Error('DOCX library not initialized');
    }

    const { Document } = this.docxLibrary;

    try {
      return new Document({
        creator: 'Robust HTML to DOCX Converter',
        title: options.filename?.replace('.docx', '') || 'Document',
        sections: [{
          properties: {
            page: {
              size: {
                orientation: options.orientation === 'landscape' ? 'landscape' : 'portrait',
                width: options.pageSize === 'Letter' ? 12240 : 11906,
                height: options.pageSize === 'Letter' ? 15840 : 16838
              },
              margin: {
                top: (options.margins?.top || 1.0) * 1440,
                right: (options.margins?.right || 1.0) * 1440,
                bottom: (options.margins?.bottom || 1.0) * 1440,
                left: (options.margins?.left || 1.0) * 1440,
              }
            }
          },
          children: docxElements
        }]
      });
    } catch (error) {
      console.error('Error creating document:', error);
      throw new Error(`Document creation failed: ${error}`);
    }
  }

  // Safe document generation and saving
  private async generateAndSaveDocument(docxDocument: any, filename: string): Promise<void> {
    if (!this.docxLibrary || !this.fileSaverLibrary) {
      throw new Error('Libraries not initialized');
    }

    const { Packer } = this.docxLibrary;
    const { saveAs } = this.fileSaverLibrary;

    try {
      console.log('Generating document blob...');
      
      // Generate with timeout
      const blobPromise = Packer.toBlob(docxDocument);
      const timeoutPromise = new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Document generation timeout')), 30000)
      );

      const blob = await Promise.race([blobPromise, timeoutPromise]) as Blob;
      
      console.log('Blob generated, size:', blob.size);
      
      if (blob.size === 0) {
        throw new Error('Generated document is empty');
      }

      // Save with error handling
      try {
        saveAs(blob, filename);
        console.log('File saved successfully');
      } catch (saveError) {
        console.error('Save error:', saveError);
        // Fallback download method
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
        console.log('File saved using fallback method');
      }

    } catch (error) {
      console.error('Error generating/saving document:', error);
      throw new Error(`Document generation failed: ${error}`);
    }
  }

  // Helper methods with error handling
  private extractStyles(computedStyle: CSSStyleDeclaration): CSSStyles {
    try {
      return {
        fontSize: this.parseFontSize(computedStyle.fontSize) || 12,
        fontFamily: this.parseFontFamily(computedStyle.fontFamily) || 'Arial',
        fontWeight: computedStyle.fontWeight || 'normal',
        fontStyle: computedStyle.fontStyle || 'normal',
        textDecoration: computedStyle.textDecoration || 'none',
        color: this.parseColor(computedStyle.color) || '#000000',
        backgroundColor: this.parseColor(computedStyle.backgroundColor) || '',
        textAlign: computedStyle.textAlign || 'left',
        lineHeight: this.parseLineHeight(computedStyle.lineHeight, computedStyle.fontSize) || 1.2,
        marginTop: this.parseSize(computedStyle.marginTop) || 0,
        marginBottom: this.parseSize(computedStyle.marginBottom) || 0,
        marginLeft: this.parseSize(computedStyle.marginLeft) || 0,
        marginRight: this.parseSize(computedStyle.marginRight) || 0,
        paddingTop: this.parseSize(computedStyle.paddingTop) || 0,
        paddingBottom: this.parseSize(computedStyle.paddingBottom) || 0,
        paddingLeft: this.parseSize(computedStyle.paddingLeft) || 0,
        paddingRight: this.parseSize(computedStyle.paddingRight) || 0,
        borderColor: this.parseColor(computedStyle.borderColor) || '',
        borderWidth: this.parseSize(computedStyle.borderWidth) || 0,
        borderStyle: computedStyle.borderStyle || 'none'
      };
    } catch (error) {
      console.warn('Error extracting styles:', error);
      return {
        fontSize: 12,
        fontFamily: 'Arial',
        fontWeight: 'normal',
        fontStyle: 'normal',
        textDecoration: 'none',
        color: '#000000',
        textAlign: 'left',
        lineHeight: 1.2
      };
    }
  }

  private createSafeTextRun(element: StyledElement, TextRun: any, UnderlineType: any): any {
    try {
      const textRunOptions: any = {
        text: element.textContent || ''
      };

      // Apply font styling with error handling
      if (element.styles.fontSize && element.styles.fontSize > 0) {
        textRunOptions.size = Math.round(Math.max(element.styles.fontSize * 2, 16)); // Minimum 8pt
      }

      if (element.styles.fontFamily) {
        textRunOptions.font = element.styles.fontFamily;
      }

      // Apply text formatting
      if (element.styles.fontWeight === 'bold' || 
          (typeof element.styles.fontWeight === 'number' && element.styles.fontWeight >= 600) ||
          ['700', '800', '900'].includes(String(element.styles.fontWeight))) {
        textRunOptions.bold = true;
      }

      if (element.styles.fontStyle === 'italic') {
        textRunOptions.italics = true;
      }

      if (element.styles.textDecoration?.includes('underline')) {
        textRunOptions.underline = { type: UnderlineType.SINGLE };
      }

      if (element.styles.color && element.styles.color !== '#000000' && element.styles.color !== 'rgb(0, 0, 0)') {
        const hexColor = this.convertColorToHex(element.styles.color);
        if (hexColor && hexColor !== '000000') {
          textRunOptions.color = hexColor;
        }
      }

      return new TextRun(textRunOptions);
    } catch (error) {
      console.warn('Error creating text run:', error);
      return new TextRun(element.textContent || '');
    }
  }

  private processSafeInlineElements(element: StyledElement, TextRun: any, UnderlineType: any): any[] {
    const textRuns: any[] = [];

    try {
      if (element.textContent.trim()) {
        textRuns.push(this.createSafeTextRun(element, TextRun, UnderlineType));
      }

      if (element.children) {
        for (const child of element.children) {
          if (['span', 'strong', 'b', 'em', 'i', 'u', 'a'].includes(child.tagName)) {
            try {
              textRuns.push(this.createSafeTextRun(child, TextRun, UnderlineType));
            } catch (childError) {
              console.warn('Error processing inline child:', childError);
              textRuns.push(new TextRun(child.textContent || ''));
            }
          }
        }
      }
    } catch (error) {
      console.warn('Error processing inline elements:', error);
    }

    // Ensure we have at least one text run
    if (textRuns.length === 0) {
      textRuns.push(new TextRun(element.textContent || ''));
    }

    return textRuns;
  }

  private async createSafeTable(
    element: StyledElement, 
    Table: any, 
    TableRow: any, 
    TableCell: any, 
    Paragraph: any, 
    TextRun: any, 
    UnderlineType: any, 
    BorderStyle: any, 
    WidthType: any
  ): Promise<any | null> {
    try {
      const rows: any[] = [];

      if (element.children) {
        for (const child of element.children) {
          if (child.tagName === 'tr') {
            const cells: any[] = [];
            
            if (child.children) {
              for (const cellChild of child.children) {
                if (['td', 'th'].includes(cellChild.tagName)) {
                  try {
                    cells.push(new TableCell({
                      children: [new Paragraph({
                        children: [this.createSafeTextRun(cellChild, TextRun, UnderlineType)]
                      })],
                      margins: {
                        top: this.convertToTwips(cellChild.styles.paddingTop || 5),
                        bottom: this.convertToTwips(cellChild.styles.paddingBottom || 5),
                        left: this.convertToTwips(cellChild.styles.paddingLeft || 5),
                        right: this.convertToTwips(cellChild.styles.paddingRight || 5)
                      },
                      borders: cellChild.styles.borderWidth ? {
                        top: { style: BorderStyle.SINGLE, size: Math.max(Math.round(cellChild.styles.borderWidth), 1) },
                        bottom: { style: BorderStyle.SINGLE, size: Math.max(Math.round(cellChild.styles.borderWidth), 1) },
                        left: { style: BorderStyle.SINGLE, size: Math.max(Math.round(cellChild.styles.borderWidth), 1) },
                        right: { style: BorderStyle.SINGLE, size: Math.max(Math.round(cellChild.styles.borderWidth), 1) }
                      } : undefined
                    }));
                  } catch (cellError) {
                    console.warn('Error creating table cell:', cellError);
                    // Fallback cell
                    cells.push(new TableCell({
                      children: [new Paragraph({
                        children: [new TextRun(cellChild.textContent || '')]
                      })]
                    }));
                  }
                }
              }
            }
            
            if (cells.length > 0) {
              rows.push(new TableRow({ children: cells }));
            }
          }
        }
      }

      if (rows.length > 0) {
        return new Table({
          rows,
          width: { size: 100, type: WidthType.PERCENTAGE }
        });
      }
    } catch (error) {
      console.warn('Error creating table:', error);
    }

    return null;
  }

  // Utility methods with enhanced error handling
  private parseFontSize(fontSize: string): number {
    try {
      const match = fontSize.match(/(\d+(?:\.\d+)?)px/);
      const size = match ? parseFloat(match[1]) : 12;
      return Math.max(Math.min(size, 72), 8); // Between 8pt and 72pt
    } catch {
      return 12;
    }
  }

  private parseFontFamily(fontFamily: string): string {
    try {
      const cleaned = fontFamily.replace(/['"]/g, '').split(',')[0].trim();
      return cleaned || 'Arial';
    } catch {
      return 'Arial';
    }
  }

  private parseColor(color: string): string {
    try {
      if (!color || color === 'rgba(0, 0, 0, 0)' || color === 'transparent') {
        return '';
      }
      return color;
    } catch {
      return '';
    }
  }

  private parseLineHeight(lineHeight: string, fontSize: string): number {
    try {
      if (lineHeight === 'normal') return 1.2;
      
      const lineHeightMatch = lineHeight.match(/(\d+(?:\.\d+)?)(?:px)?/);
      const fontSizeMatch = fontSize.match(/(\d+(?:\.\d+)?)px/);
      
      if (lineHeightMatch && fontSizeMatch) {
        const lineHeightValue = parseFloat(lineHeightMatch[1]);
        const fontSizeValue = parseFloat(fontSizeMatch[1]);
        
        if (lineHeight.includes('px')) {
          const ratio = lineHeightValue / fontSizeValue;
          return Math.max(Math.min(ratio, 3.0), 0.8); // Between 0.8 and 3.0
        } else {
          return Math.max(Math.min(lineHeightValue, 3.0), 0.8);
        }
      }
      
      return 1.2;
    } catch {
      return 1.2;
    }
  }

  private parseSize(size: string): number {
    try {
      const match = size.match(/(\d+(?:\.\d+)?)px/);
      const pixels = match ? parseFloat(match[1]) : 0;
      return Math.max(pixels, 0);
    } catch {
      return 0;
    }
  }

  private getTextContent(element: HTMLElement): string {
    try {
      const childNodes = Array.from(element.childNodes);
      let text = '';
      for (const child of childNodes) {
        if (child.nodeType === Node.TEXT_NODE) {
          text += child.textContent || '';
        }
      }
      return text.trim();
    } catch {
      return element.textContent || '';
    }
  }

  private getElementAttributes(element: HTMLElement): { [key: string]: string } {
    try {
      const attributes: { [key: string]: string } = {};
      const elementAttributes = Array.from(element.attributes);
      for (const attr of elementAttributes) {
        attributes[attr.name] = attr.value;
      }
      return attributes;
    } catch {
      return {};
    }
  }

  private getTextAlignment(textAlign?: string, AlignmentType?: any): any {
    try {
      if (!AlignmentType) return undefined;
      
      switch (textAlign) {
        case 'center': return AlignmentType.CENTER;
        case 'right': return AlignmentType.RIGHT;
        case 'justify': return AlignmentType.JUSTIFIED;
        default: return AlignmentType.LEFT;
      }
    } catch {
      return undefined;
    }
  }

  private convertToTwips(pixels: number): number {
    try {
      // Convert pixels to twips (1 inch = 1440 twips, 96 pixels = 1 inch)
      const twips = Math.round(Math.max(pixels, 0) * 15);
      return Math.min(twips, 7200); // Max 5 inches
    } catch {
      return 0;
    }
  }

  private convertColorToHex(color: string): string {
    try {
      if (color.startsWith('#')) {
        const hex = color.substring(1);
        return hex.length === 6 ? hex : '000000';
      }
      
      if (color.startsWith('rgb')) {
        const matches = color.match(/\d+/g);
        if (matches && matches.length >= 3) {
          const r = Math.max(0, Math.min(255, parseInt(matches[0]))).toString(16).padStart(2, '0');
          const g = Math.max(0, Math.min(255, parseInt(matches[1]))).toString(16).padStart(2, '0');
          const b = Math.max(0, Math.min(255, parseInt(matches[2]))).toString(16).padStart(2, '0');
          return r + g + b;
        }
      }
      
      // Named colors
      const namedColors: { [key: string]: string } = {
        'black': '000000', 'white': 'ffffff', 'red': 'ff0000',
        'green': '008000', 'blue': '0000ff', 'yellow': 'ffff00',
        'cyan': '00ffff', 'magenta': 'ff00ff', 'silver': 'c0c0c0',
        'gray': '808080', 'maroon': '800000', 'olive': '808000',
        'lime': '00ff00', 'aqua': '00ffff', 'teal': '008080',
        'navy': '000080', 'fuchsia': 'ff00ff'
      };
      
      return namedColors[color.toLowerCase()] || '000000';
    } catch {
      return '000000';
    }
  }

  // Enhanced validation method
  validateCSSSupport(htmlContent: string): { supported: string[]; unsupported: string[] } {
    const supported: string[] = [];
    const unsupported: string[] = [];
    
    try {
      const supportedProperties = [
        'font-size', 'font-family', 'font-weight', 'font-style',
        'color', 'background-color', 'text-align', 'text-decoration',
        'margin-top', 'margin-bottom', 'margin-left', 'margin-right',
        'padding-top', 'padding-bottom', 'padding-left', 'padding-right',
        'border-color', 'border-width', 'border-style', 'line-height'
      ];
      
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = htmlContent;
      
      const allElements = Array.from(tempDiv.querySelectorAll('*'));
      for (const element of allElements) {
        try {
          const computedStyle = window.getComputedStyle(element as Element);
          
          for (const prop of supportedProperties) {
            try {
              const value = computedStyle.getPropertyValue(prop);
              if (value && value !== 'initial' && value !== 'normal' && value !== '0px' && value !== 'auto') {
                if (!supported.includes(prop)) {
                  supported.push(prop);
                }
              }
            } catch (propError) {
              console.warn(`Error checking property ${prop}:`, propError);
            }
          }
        } catch (elementError) {
          console.warn('Error checking element styles:', elementError);
        }
      }
      
      // Check for unsupported properties
      const unsupportedProperties = [
        'transform', 'animation', 'transition', 'box-shadow',
        'border-radius', 'opacity', 'position', 'z-index',
        'display', 'float', 'flex', 'grid'
      ];
      
      for (const prop of unsupportedProperties) {
        if (htmlContent.toLowerCase().includes(prop.toLowerCase())) {
          if (!unsupported.includes(prop)) {
            unsupported.push(prop);
          }
        }
      }
    } catch (error) {
      console.warn('Error validating CSS support:', error);
    }
    
    return { supported, unsupported };
  }

  // Simple conversion method for fallback
  async simpleHtmlToDocx(htmlContent: string, filename: string = 'document.docx'): Promise<void> {
    try {
      await this.initializeLibraries();
      
      if (!this.docxLibrary) {
        throw new Error('DOCX library not available');
      }

      const { Document, Paragraph, TextRun, Packer } = this.docxLibrary;
      const { saveAs } = this.fileSaverLibrary;

      // Simple text extraction
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = htmlContent;
      const textContent = tempDiv.textContent || tempDiv.innerText || '';
      
      // Split into paragraphs
      const paragraphs = textContent.split(/\n\s*\n/).filter(p => p.trim().length > 0);
      
      const docxParagraphs = paragraphs.map(text => 
        new Paragraph({
          children: [new TextRun(text.trim())]
        })
      );

      // Ensure we have at least one paragraph
      if (docxParagraphs.length === 0) {
        docxParagraphs.push(new Paragraph({
          children: [new TextRun('No content found')]
        }));
      }

      const docxDocument = new Document({
        sections: [{
          children: docxParagraphs
        }]
      });

      const blob = await Packer.toBlob(docxDocument);
      saveAs(blob, filename);

    } catch (error) {
      console.error('Error in simple conversion:', error);
      throw new Error(`Simple conversion failed: ${error}`);
    }
  }

  // Test method to verify library functionality
  async testLibraries(): Promise<{ success: boolean; error?: string }> {
    try {
      await this.initializeLibraries();
      
      // Test basic DOCX creation
      const { Document, Paragraph, TextRun, Packer } = this.docxLibrary;
      
      const testDocxDocument = new Document({
        sections: [{
          children: [
            new Paragraph({
              children: [new TextRun('Library test successful')]
            })
          ]
        }]
      });

      const blob = await Packer.toBlob(testDocxDocument);
      
      if (blob.size > 0) {
        return { success: true };
      } else {
        return { success: false, error: 'Generated document is empty' };
      }
      
    } catch (error) {
      return { 
        success: false, 
        error: error instanceof Error ? error.message : 'Unknown test error' 
      };
    }
  }

  // Reset method for recovery
  resetLibraries(): void {
    this.isInitialized = false;
    this.docxLibrary = null;
    this.fileSaverLibrary = null;
    console.log('Libraries reset for recovery');
  }
}