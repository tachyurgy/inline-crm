import { application } from "./application"

import InlineEditController from "./inline_edit_controller"
import PipelineController from "./pipeline_controller"
import ActivityFeedController from "./activity_feed_controller"

application.register("inline-edit", InlineEditController)
application.register("pipeline", PipelineController)
application.register("activity-feed", ActivityFeedController)
