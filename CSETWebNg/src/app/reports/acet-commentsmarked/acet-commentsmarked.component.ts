import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';


@Component({
  selector: 'app-acet-commentsmarked',
  templateUrl: './acet-commentsmarked.component.html',
  styleUrls: ['./acet-commentsmarked.component.scss']
})
export class AcetCommentsmarkedComponent implements OnInit {
  response: any = null;

  constructor(
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Comments Marked Report - ASET");


  }

}
