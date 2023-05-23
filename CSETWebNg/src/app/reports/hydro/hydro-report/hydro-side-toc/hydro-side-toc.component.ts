import { Component } from '@angular/core';

@Component({
  selector: 'app-hydro-side-toc',
  templateUrl: './hydro-side-toc.component.html',
  styleUrls: ['../hydro-report.component.scss', '../../../reports.scss']
})
export class HydroSideTocComponent {
  scrollToElement(element) {
    (document.getElementById(element) as HTMLElement).scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
  }
}