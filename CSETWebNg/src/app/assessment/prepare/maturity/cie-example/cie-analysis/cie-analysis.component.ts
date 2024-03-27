import { Component, ViewChild } from '@angular/core';

@Component({
  selector: 'app-cie-analysis',
  templateUrl: './cie-analysis.component.html',
  styleUrls: ['./cie-analysis.component.scss']
})
export class CieAnalysisComponent {

  @ViewChild('topScrollAnchor') topScroll;

  /**
  * Scrolls newly-displayed prepare pages at the top.
  */
  onNavigate(event) {
    this.topScroll?.nativeElement.scrollIntoView();
  }
}
