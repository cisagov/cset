import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-mat-comments',
  templateUrl: './mat-comments.component.html',
  styleUrls: ['./mat-comments.component.scss']
})
export class MatCommentsComponent implements OnInit {

  @Input()
  comment: string;

  constructor() { }

  ngOnInit(): void {
  }

}
