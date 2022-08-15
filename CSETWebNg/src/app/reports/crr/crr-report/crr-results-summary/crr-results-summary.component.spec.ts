import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrResultsSummaryComponent } from './crr-results-summary.component';

describe('CrrResultsSummaryComponent', () => {
  let component: CrrResultsSummaryComponent;
  let fixture: ComponentFixture<CrrResultsSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrResultsSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrResultsSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
