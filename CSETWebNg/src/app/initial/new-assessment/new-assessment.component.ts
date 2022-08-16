import { NumberSymbol } from '@angular/common';
import { AfterViewInit, Component, NgZone, OnInit, ViewChild, ViewEncapsulation } from '@angular/core';
import SwiperCore, { SwiperOptions, Navigation, Pagination, Virtual } from 'swiper';
import { MatDialog} from '@angular/material/dialog';
import { NewAssessmentDialogComponent } from '../../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import {
  BreakpointObserver,
  Breakpoints,
  BreakpointState
} from '@angular/cdk/layout';
import { SwiperComponent } from 'swiper/angular';

SwiperCore.use([Navigation, Pagination, Virtual]);
@Component({
  selector: 'app-new-assessment',
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss'], 
  encapsulation: ViewEncapsulation.None
})
export class NewAssessmentComponent implements OnInit, AfterViewInit {

  @ViewChild('swiper', {static: false}) swiper?: SwiperComponent;

  hoverIndex = -1;
  tempArray=[,,,,,,,,,];
  config: SwiperOptions = {
    slidesPerView: 5,
    spaceBetween: 5,
    slidesPerGroup: 1, 
    centeredSlides:true,
    loop:true, 
    breakpoints: {
      200: {
        slidesPerView:1,
        centeredSlides:true
      },
      620:{
        slidesPerView:2,
        centeredSlides: true, 
        spaceBetween: 20
      },
      800: {
        slidesPerView: 3, 
        centeredSlides:true
       
      },
      920: {
        slidesPerView:4,
        navigation: true
      },
      1220:{
        slidesPerView:5,
        centeredSlides: true, 
        navigation: true
      }
    }
  };
  constructor(public dialog:MatDialog, public breakpointObserver: BreakpointObserver, private zone: NgZone) { 
    
  }

  ngOnInit(): void {
  }
  ngAfterViewInit(): void {
    console.log(this.swiper.swiperRef)
  }
  onSwiper([swiper]){
    console.log(this.swiper);
  }
  onHover(i:number){
    this.hoverIndex = i;
  }
  onSlideChange(){}

  openDialog(){
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data:{}
    });
  }
}
