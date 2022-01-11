import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-cyote-results',
  templateUrl: './cyote-results.component.html'
})
export class CyoteResultsComponent implements OnInit {

  loading = true;

  constructor() { }

  ngOnInit(): void {

    this.loading = false;
  }

}
