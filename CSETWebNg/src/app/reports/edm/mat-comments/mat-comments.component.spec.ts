import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MatCommentsComponent } from './mat-comments.component';

describe('MatCommentsComponent', () => {
  let component: MatCommentsComponent;
  let fixture: ComponentFixture<MatCommentsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MatCommentsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MatCommentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
