context("testing cr_types")

test_that("cr_types returns correct class", {
  vcr::use_cassette("cr_types", {
    aa <- cr_types()
    expect_is(aa, "list")
    expect_is(aa$data, "data.frame")
    expect_gt(NROW(aa$data), 10)
    expect_equal(aa$facets, NULL) # there is no facets slot

    bb <- cr_types("monograph")
    expect_is(bb, "list")
    expect_is(bb$data, "data.frame")
    expect_equal(NROW(bb$data), 1)
  })
})

test_that("cr_types paging works correctly", {
  vcr::use_cassette("cr_types_pagination", {

    # doens't work when works=FALSE
    aa <- cr_types(limit = 3)
    expect_is(aa, "list")
    expect_gt(NROW(aa$data), 3)

    # works when works=TRUE
    bb <- cr_types("monograph", works=TRUE, limit = 3)
    expect_is(bb, "list")
    expect_equal(NROW(bb$data), 3)
  })
})

test_that("cr_types metadata works correctly", {
  vcr::use_cassette("cr_types_metadata", {
    expect_gt(cr_types()$meta$count, 10)
    expect_equal(cr_types("monograph", works=TRUE, limit = 3)$meta$items_per_page, 3)
  })
})

test_that("cr_types facet works correctly", {
  vcr::use_cassette("cr_types_faceting", {
    aa <- cr_types("monograph", works=TRUE, facet=TRUE, limit = 0)

    expect_is(aa, "list")
    expect_named(aa, c('meta', 'data', 'facets'))
    expect_is(aa$facets, 'list')
    expect_is(aa$facets$affiliation, 'data.frame')
    expect_is(aa$facets$orcid, 'data.frame')
  })
})

test_that("cr_types fails correctly", {
    expect_error(cr_types(types="monograph", timeout_ms = 1))
})

test_that("cr_types cursor works with progress bar", {
  vcr::use_cassette("cr_types_with_cursor_and_progress_bar", {
    expect_output(
      cr_types("journal-article", works = TRUE, cursor = "*",
        cursor_max = 90, limit = 30, .progress = TRUE),
      "======="
    )
  })
})
