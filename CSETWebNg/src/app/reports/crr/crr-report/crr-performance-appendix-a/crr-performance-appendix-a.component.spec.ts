import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrPerformanceAppendixAComponent } from './crr-performance-appendix-a.component';

describe('CrrPerformanceAppendixAComponent', () => {
  let component: CrrPerformanceAppendixAComponent;
  let fixture: ComponentFixture<CrrPerformanceAppendixAComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrPerformanceAppendixAComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrPerformanceAppendixAComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
