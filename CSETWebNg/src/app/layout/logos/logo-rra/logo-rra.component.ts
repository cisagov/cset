import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-logo-rra',
  templateUrl: './logo-rra.component.html',
  styleUrls: ['./logo-rra.component.scss']
})
export class LogoRraComponent implements OnInit {

  @Input() 
  shadow = true;

  @Input()
  hexColor = "#B43236";

  
  constructor() { }

  ngOnInit(): void {

  }

}
