import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-edm-glossary',
  templateUrl: './edm-glossary.component.html'
})
export class EdmGlossaryComponent implements OnInit {

  glossaryItems: any[];

  constructor(
    public maturitySvc: MaturityService
  ) { }

  ngOnInit(): void {
    this.maturitySvc.getGlossary('EDM').subscribe((response: any[]) => {
      this.glossaryItems = response;
    });
  }
}
