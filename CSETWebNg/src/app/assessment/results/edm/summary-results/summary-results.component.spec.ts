import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SummaryResultsComponent } from './summary-results.component';

describe('SummaryResultsComponent', () => {
  let component: SummaryResultsComponent;
  let fixture: ComponentFixture<SummaryResultsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SummaryResultsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SummaryResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
