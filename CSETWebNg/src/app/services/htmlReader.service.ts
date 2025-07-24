import { Injectable, ElementRef, Renderer2, RendererFactory2 } from "@angular/core";

@Injectable({
    providedIn: 'root'
})
export class HtmlReaderService {
    private renderer: Renderer2;

    constructor(private renderFactory: RendererFactory2){
        this.renderer = this.renderFactory.createRenderer(null, null);
    }

     // Read HTML from ElementRef
  readHtmlFromElementRef(elementRef: ElementRef): string {
    if (!elementRef?.nativeElement) {
      throw new Error('ElementRef is null or undefined');
    }
    
    return elementRef.nativeElement.innerHTML;
  }

  // Read HTML from a specific element by ID
  readHtmlById(elementId: string): string {
    const element = document.getElementById(elementId);
    if (!element) {
      throw new Error(`Element with ID '${elementId}' not found`);
    }
    
    return element.innerHTML;
  }

  // Read HTML from element by class name (first match)
  readHtmlByClassName(className: string): string {
    const element = document.getElementsByClassName(className)[0] as HTMLElement;
    if (!element) {
      throw new Error(`Element with class '${className}' not found`);
    }
    
    return element.innerHTML;
  }

  // Read HTML from element by CSS selector
  readHtmlBySelector(selector: string): string {
    const element = document.querySelector(selector) as HTMLElement;
    if (!element) {
      throw new Error(`Element with selector '${selector}' not found`);
    }
    
    return element.innerHTML;
  }

  // Read outer HTML (includes the element itself)
  readOuterHtml(elementRef: ElementRef): string {
    if (!elementRef?.nativeElement) {
      throw new Error('ElementRef is null or undefined');
    }
    
    return elementRef.nativeElement.outerHTML;
  }

}