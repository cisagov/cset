import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrPerformanceSummaryComponent } from './crr-performance-summary.component';

describe('CrrPerformanceSummaryComponent', () => {
  let component: CrrPerformanceSummaryComponent;
  let fixture: ComponentFixture<CrrPerformanceSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrPerformanceSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrPerformanceSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
