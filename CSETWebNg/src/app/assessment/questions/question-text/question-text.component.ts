import { Component, ComponentFactoryResolver, ComponentRef, ElementRef, Injector, Input, OnInit, Renderer2, ViewChild } from '@angular/core';
import { GlossaryTermComponent } from './glossary-term/glossary-term.component';

@Component({
  selector: 'app-question-text',
  templateUrl: './question-text.component.html'
})
export class QuestionTextComponent implements OnInit {

  @ViewChild('para') para: ElementRef<HTMLElement>;

  @Input() questionText;

  @Input() glossaryEntries: any[];


  constructor(
    private resolver: ComponentFactoryResolver,
    private injector: Injector,
    private renderer: Renderer2
  ) { }

  ngOnInit(): void {

    // dummy code
    this.glossaryEntries = [{
      term: 'services',
      definition: 'Services - A funeral gathering for a dead person'
    },
    {
      term: 'assets',
      definition: '<em>stuff</em> that you have'
    }];


  }

  ngAfterViewInit() {
    this.buildQuestionTextWithGlossary();
  }

  /**
   * Using this page as a reference for dynamically creating and inserting glossary-term components:
   * https://stackoverflow.com/questions/60284184/how-to-dynamically-apply-a-tooltip-to-part-of-an-elements-dynamic-text-content
   */
  buildQuestionTextWithGlossary() {
    const pieces = this.questionText.split(']]');
    pieces.forEach((x: string) => {
      const startBracketPos = x.lastIndexOf('[[');
      if (startBracketPos >= 0) {
        const leadingText = x.substring(0, startBracketPos);
        const term = x.substring(startBracketPos + 2);

        const entry = this.glossaryEntries.find(x => x.term == term);

        // append text before the glossary term
        this.renderer.appendChild(
          this.para.nativeElement,
          this.renderer.createText(leadingText)
        );

        // create and append a GlossaryTerm component 
        let factory = this.resolver.resolveComponentFactory(GlossaryTermComponent);
        let ref = factory.create(this.injector);
        ref.instance.term = term;
        ref.instance.definition = !!entry ? entry.definition : term;

        ref.changeDetectorRef.detectChanges();
        this.renderer.appendChild(
          this.para.nativeElement,
          ref.location.nativeElement
        );
      } else {
        // no starter bracket, just dump the text
        this.renderer.appendChild(
          this.para.nativeElement,
          this.renderer.createText(x)
        );
      }
    });
  }

}
