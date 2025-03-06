import { Component, ViewChild } from '@angular/core';

@Component({
    selector: 'app-tutorial-cie',
    templateUrl: './tutorial-cie.component.html',
    styleUrls: ['./tutorial-cie.component.scss'],
    standalone: false
})
export class TutorialCieComponent {

  @ViewChild('topScrollAnchor') topScroll;

  /**
  * Scrolls newly-displayed prepare pages at the top.
  */
  onNavigate(event) {
    this.topScroll?.nativeElement.scrollIntoView();
  }
}
