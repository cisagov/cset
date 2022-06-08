import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SectionScoringComponent } from './section-scoring.component';

describe('SectionScoringComponent', () => {
  let component: SectionScoringComponent;
  let fixture: ComponentFixture<SectionScoringComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SectionScoringComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SectionScoringComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
