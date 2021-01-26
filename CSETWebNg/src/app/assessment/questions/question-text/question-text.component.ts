import { Component, ComponentFactoryResolver, ComponentRef, ElementRef, Injector, Input, OnInit, Renderer2, ViewChild } from '@angular/core';
import { MatTooltip, TooltipComponent } from '@angular/material/tooltip';

@Component({
  selector: 'app-question-text',
  templateUrl: './question-text.component.html'
})
export class QuestionTextComponent implements OnInit {

  @ViewChild('para') para: ElementRef<HTMLElement>;

  @Input() questionText;

  @Input() glossaryEntries: any[];

  private tooltip: ComponentRef<MatTooltip>;

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
      definition: 'stuff that you have'
    }];


  }

  ngAfterViewInit() {
    this.buildQuestionTextWithGlossary();
  }

  /**
   * Using this page as a reference for dynamically creating and inserting tooltip items:
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

        this.renderer.appendChild(
          this.para.nativeElement,
          this.renderer.createText(leadingText)
        );

        // ---- This code is an attempt to create the tooltip.  Not working yet.
        // ---- In the meantime, there is somem dummy code below to keep the question text intact.
        // let factory = this.resolver.resolveComponentFactory(TooltipComponent);
        // let ref = factory.create(this.injector);
        // ref.instance.text = term;
        // ref.instance.message = 'I AM A TOOLTIP.  HEAR ME ROAR!';
        // ref.instance.tooltipClass = 'glossary-term';
        // ref.changeDetectorRef.detectChanges();
        // this.renderer.appendChild(
        //   this.para.nativeElement,
        //   ref.location.nativeElement
        // );

        // ---- This is dummy code, just to get the glossary term rendered into the question.
        // ---- Once we get the real tooltip working, delete this.
        const span = this.renderer.createElement('span');
        span.innerText = term;
        span.setAttribute('class', 'glossary-term');
        span.setAttribute('title', !!entry ? entry.definition : term);

        this.renderer.appendChild(
          this.para.nativeElement,
          span
        );
        // ---- End of dummy code

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
