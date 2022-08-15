import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrNistCsfSummaryComponent } from './crr-nist-csf-summary.component';

describe('CrrNistCsfSummaryComponent', () => {
  let component: CrrNistCsfSummaryComponent;
  let fixture: ComponentFixture<CrrNistCsfSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrNistCsfSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrNistCsfSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
