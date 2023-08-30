import { Component } from '@angular/core';

@Component({
  selector: 'app-imr-side-toc',
  templateUrl: './imr-side-toc.component.html',
  styleUrls: ['../imr-report/imr-report.component.scss']
})
export class ImrSideTocComponent {

  scrollToElement(element) {
    (document.getElementById(element) as HTMLElement).scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
  }
}
