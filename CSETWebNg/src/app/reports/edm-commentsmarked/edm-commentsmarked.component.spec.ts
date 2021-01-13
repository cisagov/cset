import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EdmCommentsmarkedComponent } from './edm-commentsmarked.component';

describe('EdmCommentsmarkedComponent', () => {
  let component: EdmCommentsmarkedComponent;
  let fixture: ComponentFixture<EdmCommentsmarkedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EdmCommentsmarkedComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EdmCommentsmarkedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
