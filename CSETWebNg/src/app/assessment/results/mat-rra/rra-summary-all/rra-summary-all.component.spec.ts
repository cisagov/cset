import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraSummaryAllComponent } from './rra-summary-all.component';

describe('RraSummaryAllComponent', () => {
  let component: RraSummaryAllComponent;
  let fixture: ComponentFixture<RraSummaryAllComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraSummaryAllComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraSummaryAllComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
