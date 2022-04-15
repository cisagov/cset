import { Component, Input, OnInit } from '@angular/core';
import { NumberCardModule } from '@swimlane/ngx-charts';

@Component({
  selector: 'app-logo-cset',
  templateUrl: './logo-cset.component.html',
  styleUrls: ['./logo-cset.component.scss']
})
export class LogoCsetComponent implements OnInit {

  @Input() 
  mode: string;

  @Input()
  logoHeight = 28;

  logoWidth: number;

  color1: string;
  color2: string;

  constructor() { }

  ngOnInit(): void {
    this.logoWidth = this.logoHeight * 4.28;

    if (this.mode == 'white') {
      this.color1 = 'fill-primary';
      this.color2 = 'fill-white';
    } else {
      this.color1 = 'fill-white';
      this.color2 = 'fill-primary';
    }
  }

}
