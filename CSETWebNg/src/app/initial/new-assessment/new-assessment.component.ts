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
import { GalleryService } from '../../services/gallery.service';

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
  config: SwiperOptions = {
    slidesPerView: 1,
    spaceBetween: 5,
    slidesPerGroup: 1, 
    centeredSlides:true,
    loop:true, 
    navigation:true,
    breakpoints: {
      200: {
        slidesPerView:1,
        centeredSlides:true
      },
      620:{
        slidesPerView:2,
        centeredSlides: true
      },
      800: {
        slidesPerView: 3, 
        centeredSlides:true
      },
      1220:{
        slidesPerView:5,
        centeredSlides: true
      }
    }, 
    on: {
      resize: ()=>{
        this.checkNavigation();
      }
    }
  };

  galleryData: any;
  rows: any;

  constructor(public dialog:MatDialog, 
    public breakpointObserver: BreakpointObserver, 
    public gallerySvc: GalleryService,
    private zone: NgZone) { 
    
  }

  ngOnInit(): void {
    this.gallerySvc.getGalleryItems("CSET").subscribe(
      (resp: any) => {
        this.galleryData = resp;
        this.rows = this.galleryData.rows;
      }
    );
    setTimeout(() => {
      this.checkNavigation();
    });
    
  }
  ngAfterViewInit(): void {
    this.checkNavigation();
  }

  checkNavigation(){
    let swiperPrev = document.querySelector('.swiper-button-prev');
    let swiperNext = document.querySelector('.swiper-button-next');
    if(window.innerWidth < 620){
     
      if(swiperPrev != null && swiperNext != null){
        swiperPrev.setAttribute('style','display:none');
        swiperNext.setAttribute('style','display:none');
      }
    } else {
      if(swiperPrev != null && swiperNext != null){
        swiperPrev.removeAttribute('style');
        swiperNext.removeAttribute('style');
      }
    }
  }

   onSwiper([swiper]){
      console.log(swiper);
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
