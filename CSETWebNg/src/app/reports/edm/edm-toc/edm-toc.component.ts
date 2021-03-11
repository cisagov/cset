import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-toc',
  templateUrl: './edm-toc.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmTocComponent implements OnInit {

  /**
   * Indicates how the TOC is being used:  sidenav | main  
   */
  @Input()
  usage = "";
  
  /**
   * 
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  /**
   * 
   * @param el 
   */
  scroll(eId: string) {
    const element = document.getElementById(eId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  }
}
