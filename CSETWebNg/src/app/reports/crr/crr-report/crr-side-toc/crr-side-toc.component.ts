import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-crr-side-toc',
  templateUrl: './crr-side-toc.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrSideTocComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  scrollToElement(element) {
    (document.getElementById(element) as HTMLElement).scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
  }

}
