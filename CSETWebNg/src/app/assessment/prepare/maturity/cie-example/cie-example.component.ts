import { Component, ViewChild } from '@angular/core';

@Component({
  selector: 'app-cie-example',
  templateUrl: './cie-example.component.html',
  styleUrls: ['./cie-example.component.scss']
})
export class CieExampleComponent {

  @ViewChild('topScrollAnchor') topScroll;

  /**
  * Scrolls newly-displayed prepare pages at the top.
  */
  onNavigate(event) {
    this.topScroll?.nativeElement.scrollIntoView();
  }
}
