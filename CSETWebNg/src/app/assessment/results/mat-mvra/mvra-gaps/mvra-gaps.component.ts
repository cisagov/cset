import { Component, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-mvra-gaps',
  templateUrl: './mvra-gaps.component.html',
  styleUrls: ['./mvra-gaps.component.scss']
})
export class MvraGapsComponent implements OnInit {
  model:any = [];
  errors:any;
  initialized: boolean = false;
  constructor(public maturitySvc: MaturityService) { }

  ngOnInit(): void {
    this.maturitySvc.getMvraScoring().subscribe(
      (r: any) => {
        console.log(r)
        this.model = r;
        this.initialized = true;
      },
      error => {
        this.errors = true;
        console.log('Mvra Gaps load Error: ' + (<Error>error).message);
      }
      ), 
      (finish) => {
    };
  }
}
