import { application } from "./application"

import InlineEditController from "./inline_edit_controller"
import PipelineController from "./pipeline_controller"
import ActivityFeedController from "./activity_feed_controller"
import SearchController from "./search_controller"
import FlashController from "./flash_controller"
import NoteFormController from "./note_form_controller"

application.register("inline-edit", InlineEditController)
application.register("pipeline", PipelineController)
application.register("activity-feed", ActivityFeedController)
application.register("search", SearchController)
application.register("flash", FlashController)
application.register("note-form", NoteFormController)
