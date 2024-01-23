////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, ComponentFactoryResolver, ElementRef, Injector, Input, Renderer2, ViewChild, AfterViewInit } from '@angular/core';
import { GlossaryService } from '../../../services/glossary.service';
import { GlossaryTermComponent } from '../question-text/glossary-term/glossary-term.component';

@Component({
  selector: 'app-grouping-description',
  templateUrl: './grouping-description.component.html'
})
export class GroupingDescriptionComponent implements AfterViewInit {

  @Input()
  text: string;

  @ViewChild('para') para: ElementRef<HTMLElement>;

  @Input() glossaryEntries: any[];

  constructor(
    private resolver: ComponentFactoryResolver,
    private injector: Injector,
    private renderer: Renderer2,
    private glossarySvc: GlossaryService
  ) { }

  /**
   * 
   */
  ngAfterViewInit() {
    this.buildTextWithGlossary();
  }

  /**
   * Using this page as a reference for dynamically creating and inserting glossary-term components:
   * https://stackoverflow.com/questions/60284184/how-to-dynamically-apply-a-tooltip-to-part-of-an-elements-dynamic-text-content
   */
  buildTextWithGlossary() {
    const pieces = this.text.split(']]');
    pieces.forEach((x: string) => {
      const startBracketPos = x.lastIndexOf('[[');
      if (startBracketPos >= 0) {
        const leadingText = x.substring(0, startBracketPos);
        let term = x.substring(startBracketPos + 2);
        let displayWord = term;

        if (term.indexOf('|') > 0) {
          const p = term.split('|');
          term = p[0];
          displayWord = p[1];
        }

        const entry = this.glossarySvc.glossaryEntries.find(x => x.term.toLowerCase() == term.toLowerCase());

        // append text before the glossary term
        const span = this.renderer.createElement('span');
        span.innerHTML = leadingText;
        this.renderer.appendChild(
          this.para.nativeElement,
          span
        );

        // create and append a GlossaryTerm component 
        let factory = this.resolver.resolveComponentFactory(GlossaryTermComponent);
        let ref = factory.create(this.injector);
        ref.instance.term = entry.term;
        ref.instance.definition = !!entry ? entry.definition : displayWord;
        ref.instance.displayWord = displayWord;

        ref.changeDetectorRef.detectChanges();
        this.renderer.appendChild(
          this.para.nativeElement,
          ref.location.nativeElement
        );
      } else {
        // no starter bracket, just dump the text
        const span = this.renderer.createElement('span');
        span.innerHTML = x;
        this.renderer.appendChild(
          this.para.nativeElement,
          span
        );
      }
    });
  }
}
